module StackerBee
  module Middleware
    class CloudStackAPI < Base
      RESPONSE_TYPE = "json"

      def before(env)
        env.request.params.merge!(
          api_key: api_key,
          command: env.request.endpoint_name,
          response: RESPONSE_TYPE
        )
      end
    end
  end
end
