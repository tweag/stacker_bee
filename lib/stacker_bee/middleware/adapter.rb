module StackerBee
  module Middleware
    class Adapter < Base
      def endpoint_name_for(*)
      end

      def call(env)
        request = Request.new(env.request.endpoint_name,
                              env.request.api_key,
                              env.request.params)
        env.raw_response = connection.get(request)
        env.response = Response.new(env.raw_response)
      end
    end
  end
end
