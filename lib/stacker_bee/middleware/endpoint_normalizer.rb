module StackerBee
  module Middleware
    class EndpointNormalizer < Base
      def before(env)
        new_endpoint_name = endpoint_name_for(env.request.endpoint_name)
        env.request.endpoint_name = new_endpoint_name if new_endpoint_name
      end

      def endpoint_name_for(name)
        # TODO: shouldn't this be in the base endpoint?
        fail "API required" unless api
        endpoint_description = api[name]
        if endpoint_description
          endpoint_description.fetch("name")
        else
          super
        end
      end
    end
  end
end
