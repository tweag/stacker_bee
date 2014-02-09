module StackerBee
  module Middleware
    class EndpointNormalizer < Base
      def call(env)
        env.request.endpoint_name = endpoint_name_for(env.request.endpoint_name)
        app.call(env)
      end

      def endpoint_name_for(name)
        # TODO: shouldn't this be in the base endpoint?
        raise "API required" unless api
        endpoint_description = api[name]
        endpoint_description.fetch("name") if endpoint_description
      end
    end
  end
end
