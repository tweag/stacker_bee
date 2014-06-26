module StackerBee
  module Middleware
    class LogResponse < Base
      def after(env)
        return unless env.logger
        params = env.request.params.to_a.sort
        log_data = {
          request_path: env.request.path,
          params: params,
          response_body: env.raw_response[:body],
        }

        if env.response.success?
          log_data[:short_message] = params.find { |key, _| key == "command" }.last
          env.logger.info log_data
        else
          command = params.find { |key, _| key == "command" }.last
          log_data[:short_message] = "#{command} failed: #{env.response.error}"
          env.logger.error log_data
        end
      end

      def content_types
        /javascript/
      end
    end
  end
end
