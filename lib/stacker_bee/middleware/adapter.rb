module StackerBee
  module Middleware
    class Adapter < Base
      def call(env)
        perform_request env
        pluck_content_type env
        pluck_body env
      end

      def pluck_content_type(env)
        env.response.content_type =
          env.raw_response.env[:response_headers]['content-type']
      end

      def pluck_body(env)
        env.response.body = env.raw_response.body
      end

      def perform_request(env)
        params = env.request.params.to_a.sort
        env.raw_response = connection.get(env.request.path, params)
      end

      def endpoint_name_for(*)
      end
    end
  end
end
