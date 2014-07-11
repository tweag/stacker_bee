module StackerBee
  module Middleware
    class Base < OpenStruct
      def call(env)
        before env
        app.call env
        after env if matches_content_type?(env)
      end

      def matches_content_type?(env)
        content_types.nil? || content_types =~ env.response.content_type
      end

      def content_types
      end

      def before(env)
        env.request.params = transform_params(env.request.params)
      end

      def after(env)
      end

      def transform_params(params)
        params
      end

      def endpoint_name_for(endpoint_name)
        app.endpoint_name_for(endpoint_name)
      end
    end
  end
end
