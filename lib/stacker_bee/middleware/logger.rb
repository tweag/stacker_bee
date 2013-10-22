require 'forwardable'
require 'logger'
require 'pp'

module StackerBee
  module Middleware
    class Logger < Faraday::Response::Middleware
      extend Forwardable
      PROGNAME = "StackerBee"

      attr_accessor :logger

      def initialize(app, logger = nil)
        super(app)
        self.logger = logger
        self.logger.progname ||= PROGNAME
      end

      def logger
        @logger ||= ::Logger.new($stdout)
      end

      def_delegators :logger, :debug, :info, :warn, :error, :fatal

      def call(env)
        log_request(env)
        super
      end

      def on_complete(env)
        log_response(env)
      end

      def log_request(env)
        info  "#{env[:method]} #{env[:url]}"
        debug env[:request_headers].pretty_inspect
      end

      def log_response(env)
        status_message = "Status: #{env[:status]}"
        env[:status] < 400 ? info(status_message) : error(status_message)
        debug env[:response_headers].pretty_inspect
        debug env[:body]
      end

    end
  end
end
