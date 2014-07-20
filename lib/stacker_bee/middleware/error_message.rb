module StackerBee
  module Middleware
    class ErrorMessage < Base
      def after(env)
        return if env.response.success?

        env.response.error = env.response.body[:errortext]
      end

      def content_types
        /javascript/
      end
    end
  end
end
