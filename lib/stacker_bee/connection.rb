require "faraday"
require "stacker_bee/middleware/signed_query"
require "stacker_bee/middleware/logger"

module StackerBee
  class Connection
    def initialize(configuration)
      @faraday = Faraday.new(url: configuration.url) do |faraday|
        faraday.use      Middleware::SignedQuery, configuration.secret_key
        faraday.use      Middleware::Logger, configuration.logger
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get(request)
      @faraday.get('', request.query_params)
    end
  end
end
