require "faraday"
require "stacker_bee/middleware/signed_query"
require "stacker_bee/middleware/logger"

module StackerBee
  class ConnectionError < Exception
  end

  class Connection
    attr_accessor :configuration
    def initialize(configuration)
      @configuration = configuration
      @faraday = Faraday.new(url: self.configuration.url) do |faraday|
        faraday.use      Middleware::SignedQuery, self.configuration.secret_key
        faraday.use      Middleware::Logger, self.configuration.logger
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get(request)
      @faraday.get('', request.query_params)
    rescue Faraday::Error::ConnectionFailed
      raise ConnectionError, "Failed to connect to #{configuration.url}"
    end
  end
end
