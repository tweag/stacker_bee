module StackerBee
  module Middleware
    class Adapter < Base
      def call(env)
        params = env.request.params.to_a.sort
        env.raw_response = connection.get(env.request.path, params)
        env.response.content_type =
          env.raw_response.env[:response_headers]["content-type"]
        env.response.body = env.raw_response.body
      end

      def endpoint_name_for(*)
      end
    end
  end
end
