require 'faraday'
require 'uri'
require 'stacker_bee/http_middleware/signed_query'
require 'stacker_bee/http_middleware/detokenizer'

module StackerBee
  class ConnectionError < StandardError
  end

  class Connection
    attr_accessor :configuration

    def initialize(config)
      self.configuration = config

      uri = URI.parse(configuration.url)
      uri.path = ''
      fail ConnectionError, 'no protocol specified' unless uri.scheme

      initialize_faraday(
        url: uri.to_s,
        ssl: { verify: configuration.ssl_verify? }
      )
    end

    def initialize_faraday(options)
      @faraday = Faraday.new(options) do |faraday|
        faraday.use HTTPMiddleware::Detokenizer
        faraday.use HTTPMiddleware::SignedQuery, configuration.secret_key
        configuration.faraday_middlewares.call faraday

        unless using_adapter?(faraday.builder.handlers)
          faraday.adapter Faraday.default_adapter  # Net::HTTP
        end
      end
    end

    def using_adapter?(handlers)
      handlers.find do |handler|
        handler.klass.ancestors.include?(Faraday::Adapter)
      end
    end

    def get(path, params)
      @faraday.get(path, params)
    rescue Faraday::Error::ConnectionFailed => error
      configuration.logger.error error if configuration.logger
      raise ConnectionError,
            "Failed to connect to #{configuration.url}, #{error}"
    end
  end
end
