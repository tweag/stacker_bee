module StackerBee
  module Middleware
    class Adapter < Base
      def call(env)
        params = env.request.params.to_a.sort
        env.raw_response = connection.get(params, env.request.path)
        env.response.content_type =
          env.raw_response.env[:response_headers]["content-type"]
      end

      def endpoint_name_for(*)
      end
    end
  end
end
