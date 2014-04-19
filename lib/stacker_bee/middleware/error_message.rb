module StackerBee
  module Middleware
    class ErrorMessage < Base
      def after(env)
        unless env.response.success?
          env.response.error = env.response.body[:errortext]
        end
      end

      def content_types
        /javascript/
      end
    end
  end
end
