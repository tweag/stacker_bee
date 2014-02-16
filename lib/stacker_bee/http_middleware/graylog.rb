module StackerBee
  module HTTPMiddleware
    class Graylog < FaradayMiddleware::Graylog
      def facility
        'stacker-bee'
      end

      def short_message(env)
        message = env[:url].query.scan(/&command=([^&]*)/).join(' ')
        "StackerBee #{message}".strip
      end
    end
  end
end
