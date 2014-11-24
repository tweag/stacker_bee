module StackerBee
  module Middleware
    class ConsoleAccess < Base
      include Utilities

      ENDPOINT = 'consoleAccess'
      PARAMS   = { cmd: 'access' }

      def before(env)
        return unless matches_endpoint?(env.request.endpoint_name)
        super
        env.request.path = console_path
        env.request.endpoint_name = ENDPOINT
      end

      def transform_params(params)
        params.merge(PARAMS)
      end

      def content_types
        /html/
      end

      def endpoint_name_for(name)
        matches_endpoint?(name) ?  ENDPOINT : super
      end

      def matches_endpoint?(name)
        uncase(name) == uncased_endpoint
      end

      def uncased_endpoint
        @uncased_endpoint ||= uncase(ENDPOINT)
      end
    end
  end
end
