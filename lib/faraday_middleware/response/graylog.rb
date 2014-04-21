require 'faraday_middleware'
require 'faraday_middleware/response_middleware'

module FaradayMiddleware
  class Graylog < ResponseMiddleware
    INFO  = 1
    ERROR = 3

    attr_accessor :facility

    def initialize(app, logger, options = {})
      @logger       = logger
      self.facility = options[:facility] || "faraday-middleware-graylog"

      super app, options
    end

    def process_response(env)
      @logger.info(
        facility:      facility,
        short_message: short_message(env),
        level:         level(env),
        _data:         env.dup.tap { |e| e.delete(:response) }
      )
    end

    def short_message(env)
      facility + " Request"
    end

    def level(env)
      env[:status] < 400 ? INFO : ERROR
    end
  end
end
