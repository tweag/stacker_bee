module StackerBee
  module Middleware
    class Base < OpenStruct
      def call(env)
        fail "Not Implemented"
      end

      def endpoint_name_for(endpoint_name)
        app.endpoint_name_for(endpoint_name)
      end
    end
  end
end
