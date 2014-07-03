module StackerBee
  module Middleware
    class LogResponse < Base
      def after(env)
        return unless env.logger
        params = env.request.params.to_a.sort
        command = params.find { |key, _| key == "command" }.last

        log(env, params, command)
      end

      def log(env, params, command)
        log_data = base_log_data(env, params)
        if env.response.success?
          log_data[:short_message] = command
          env.logger.info log_data
        else
          log_data[:short_message] = "#{command} failed: #{env.response.error}"
          env.logger.error log_data
        end
      end

      def base_log_data(env, params)
        {
          request_path: env.request.path,
          params: params,
          response_body: env.raw_response[:body]
        }
      end

      def content_types
        /javascript/
      end
    end
  end
end
