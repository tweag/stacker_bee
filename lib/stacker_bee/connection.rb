require "faraday"
require "stacker_bee/middleware/request/signed_query"

module StackerBee
  class Connection
    def initialize(configuration)
      @faraday = Faraday.new(url: configuration.url) do |faraday|
        faraday.use      Middleware::Request::SignedQuery, configuration.secret_key
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get(request)
      @faraday.get(request.path, request.query_params)
    end
  end
end
