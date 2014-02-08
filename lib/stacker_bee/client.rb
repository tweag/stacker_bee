require "forwardable"
require "ostruct"
require "stacker_bee/configuration"
require "stacker_bee/api"
require "stacker_bee/connection"
require "stacker_bee/request"
require "stacker_bee/dictionary_flattener"
require "stacker_bee/response"

module StackerBee
  class Client
    DEFAULT_API_PATH = File.join(
      File.dirname(__FILE__), '../../config/4.2.json'
    )

    extend Forwardable
    def_delegators :configuration,
                   :url,
                   :url=,
                   :api_key,
                   :api_key=,
                   :secret_key,
                   :secret_key=

    class << self
      def reset!
        @api, @api_path, @default_config = nil
      end

      def default_config
        @default_config ||= {
          allow_empty_string_params: false,
          middlewares: ->(*) {}
        }
      end

      def configuration=(config_hash)
        default_config.merge!(config_hash)
      end

      def api_path
        @api_path ||= DEFAULT_API_PATH
      end

      def api_path=(new_api_path)
        return @api_path if @api_path == new_api_path
        @api = nil
        @api_path = new_api_path
      end

      def api
        @api ||= API.new(api_path: api_path)
      end
    end

    def initialize(config = {})
      self.configuration = config
    end

    def configuration=(config)
      @configuration = configuration_with_defaults(config)
    end

    def configuration
      @configuration ||= configuration_with_defaults
    end

    def request(endpoint_name, params = {})
      env = OpenStruct.new(
        endpoint_name: endpoint_name,
        api_key:       api_key,
        params:        params
      )

      middleware_app.call(env)

      env.response
    end

    class Middleware < OpenStruct
      def call(env)
        block.call(env, app)
      end

      def has_endpoint?(endpoint_name)
        app.has_endpoint?(endpoint_name)
      end

      def endpoint_name_for(endpoint_name)
        app.endpoint_name_for(endpoint_name)
      end
    end

    class BaseMiddleware < Middleware
      def has_endpoint?(*)
        false
      end

      def endpoint_name_for(*)
      end

      def call(env)
        env.request = Request.new(env.endpoint_name, env.api_key, env.params)
        env.request.allow_empty_string_params = allow_empty_string_params
        env.raw_response = connection.get(env.request)
        env.response = Response.new(env.raw_response)
      end
    end

    class EndpointNormalizerMiddleware < Middleware
      def call(env)
        env.endpoint_name = endpoint_for(env.endpoint_name)
        app.call(env)
      end

      def endpoint_for(name)
        # TODO: shouldn't this be in the base endpoint?
        raise "API required" unless api
        endpoint_description = api[name]
        endpoint_description.fetch("name") if endpoint_description
      end

      def has_endpoint?(name)
        api.key?(name)
      end
    end

    def middleware_app
      @app ||= begin
                 middlewares = [
                   EndpointNormalizerMiddleware.new(api: self.class.api),
                   BaseMiddleware.new(
                     allow_empty_string_params: configuration.allow_empty_string_params,
                     connection: connection
                   )
                 ]

                 last_middleware = nil
                 middlewares.reverse.each do |middleware|
                   middleware.app = last_middleware
                   last_middleware = middleware
                 end

                 middlewares.first
               end
    end

    def method_missing(name, *args, &block)
      endpoint = middleware_app.endpoint_for(name)
      if endpoint
        request(endpoint, *args, &block)
      else
        super
      end
    end

    def respond_to?(name, include_private = false)
      # todo: switch the order of these
      middleware_app.has_endpoint?(name) || super
    end

    protected

    def connection
      @connection ||= Connection.new(configuration)
    end

    def configuration_with_defaults(config = {})
      config_hash = self.class.default_config.merge(config)
      Configuration.new(config_hash)
    end
  end
end
