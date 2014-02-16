module StackerBee
  module Middleware
    class DeNamespace < Base
      def after(env)
        body = env.response.body
        fail "Cannot determine response key in #{body.keys}" if body.size > 1
        env.response.body = body.values.first
      end

      def content_types
        /javascript/
      end
    end
  end
end
