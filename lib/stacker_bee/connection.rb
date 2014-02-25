require "faraday"
require "uri"
require "stacker_bee/middleware/signed_query"
require "stacker_bee/middleware/detokenizer"

module StackerBee
  class ConnectionError < StandardError
  end

  class Connection
    attr_accessor :configuration

    def initialize(configuration)
      @configuration = configuration
      uri = URI.parse(self.configuration.url)
      uri.path = ''
      ssl_verify = !self.configuration.ssl_verify.nil? ?
        self.configuration.ssl_verify : true
      fail ConnectionError, "no protocol specified" unless uri.scheme
      initialize_faraday(url: uri.to_s,
                         ssl: { verify: ssl_verify })
    end

    def initialize_faraday(options)
      @faraday = Faraday.new(options) do |faraday|
        faraday.use      Middleware::Detokenizer
        faraday.use      Middleware::SignedQuery, configuration.secret_key
        configuration.middlewares.call faraday
        faraday.adapter  Faraday.default_adapter  # Net::HTTP
      end
    end

    def get(request, path)
      @faraday.get(path, request.query_params)
    rescue Faraday::Error::ConnectionFailed => error
      raise ConnectionError,
        "Failed to connect to #{configuration.url}, #{error}"
    end
  end
end
