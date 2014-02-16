module StackerBee
  module Middleware
    class JSONBody < Base
      def after(env)
        env.response.raw_body = env.raw_response.body
        env.response.body = MultiJson.load(env.response.raw_body)
      end

      def content_types
        /javascript/
      end
    end
  end
end
