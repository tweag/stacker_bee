module StackerBee
  module Middleware
    class Adapter < Base
      def call(env)
        params = env.request.params.to_a.sort
        env.raw_response = connection.get(params)
      end
    end

    def endpoint_name_for(*)
    end
  end
end
