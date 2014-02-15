require "faraday"
require "uri"
require "stacker_bee/http_middleware/signed_query"
require "stacker_bee/http_middleware/detokenizer"

module StackerBee
  class ConnectionError < StandardError
  end

  class Connection
    attr_accessor :configuration

    def initialize(configuration)
      @configuration = configuration
      uri = URI.parse(self.configuration.url)
      uri.path = ''
      fail ConnectionError, "no protocol specified" unless uri.scheme
      initialize_faraday(uri)
    end

    def initialize_faraday(uri)
      @faraday = Faraday.new(url: uri.to_s) do |faraday|
        faraday.use HTTPMiddleware::Detokenizer
        faraday.use HTTPMiddleware::SignedQuery, configuration.secret_key

        configuration.faraday_middlewares.call faraday

        unless has_adapter?(faraday.builder.handlers)
          faraday.adapter  Faraday.default_adapter  # Net::HTTP
        end
      end
    end

    def has_adapter?(handlers)
      handlers.detect do |handler|
        handler.klass.ancestors.include?(Faraday::Adapter)
      end
    end

    def get(params, path)
      @faraday.get(path, params)
    rescue Faraday::Error::ConnectionFailed => error
      raise ConnectionError,
        "Failed to connect to #{configuration.url}, #{error}"
    end
  end
end
