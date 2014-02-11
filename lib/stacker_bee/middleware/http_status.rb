module StackerBee
  module Middleware
    class HTTPStatus < Base
      def after(env)
        env.response.status     = env.raw_response.status
        env.response[:success?] = env.raw_response.success?

        unless env.response.success?
          env.response.error = env.response.body[:errortext]
        end
      end
    end
  end
end
