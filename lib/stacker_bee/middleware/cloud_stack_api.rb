module StackerBee
  module Middleware
    class CloudStackAPI < Base
      RESPONSE_TYPE = 'json'
      DEFAULT_PATH  = '/client/api/'

      def before(env)
        env.request.params.merge!(
          api_key:  api_key,
          command:  env.request.endpoint_name,
          response: RESPONSE_TYPE
        )
        env.request.path ||= DEFAULT_PATH
      end
    end
  end
end
