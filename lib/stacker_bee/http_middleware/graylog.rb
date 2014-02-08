module StackerBee
  module HTTPMiddleware
    class Graylog < FaradayMiddleware::Graylog
      def facility
        'stacker-bee'
      end

      def short_message(env)
        message = env[:url].query.match(/&command=([^&]*)/)[1]
        "StackerBee #{message}"
      end
    end
  end
end
