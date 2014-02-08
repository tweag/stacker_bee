module StackerBee
  module Middleware
    class EndpointNormalizer < Base
      def call(env)
        env.endpoint_name = endpoint_for(env.endpoint_name)
        app.call(env)
      end

      def endpoint_for(name)
        # TODO: shouldn't this be in the base endpoint?
        raise "API required" unless api
        endpoint_description = api[name]
        endpoint_description.fetch("name") if endpoint_description
      end
    end
  end
end
