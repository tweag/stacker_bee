require "faraday"
require "uri"
require "stacker_bee/middleware/signed_query"
require "stacker_bee/middleware/logger"

module StackerBee
  class ConnectionError < Exception
  end

  class Connection
    attr_accessor :configuration
    def initialize(configuration)
      @configuration = configuration
      uri      = URI.parse(self.configuration.url)
      @path    = uri.path
      uri.path = ''
      fail ConnectionError, "no protocol specified" unless uri.scheme
      @faraday = Faraday.new(url: uri.to_s) do |faraday|
        faraday.use      Middleware::SignedQuery, self.configuration.secret_key
        faraday.use      Middleware::Logger, self.configuration.logger
        faraday.adapter  Faraday.default_adapter  # Net::HTTP
      end
    end

    def get(request)
      @faraday.get(@path, request.query_params)
    rescue Faraday::Error::ConnectionFailed
      raise ConnectionError, "Failed to connect to #{configuration.url}"
    end
  end
end
