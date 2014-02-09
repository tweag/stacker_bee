require "forwardable"
require "stacker_bee/configuration"
require "stacker_bee/api"
require "stacker_bee/connection"
require "stacker_bee/request"
require "stacker_bee/dictionary_flattener"
require "stacker_bee/response"
require "stacker_bee/middleware/environment"
require "stacker_bee/middleware/base"
require "stacker_bee/middleware/adapter"
require "stacker_bee/middleware/endpoint_normalizer"
require "stacker_bee/middleware/remove_empty_strings"

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

    def middlewares
      [
        Middleware::EndpointNormalizer.new(api: self.class.api),
        Middleware::RemoveEmptyStrings.new,
        *configuration.middlewares,
        Middleware::Adapter.new(connection: connection)
      ]
    end

    class << self
      def reset!
        @api, @api_path, @default_config = nil
      end

      def default_config
        @default_config ||= {
          faraday_middlewares: ->(*) {},
          middlewares: []
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
      env = Middleware::Environment.new(
        endpoint_name: endpoint_name,
        api_key:       api_key,
        params:        params
      )

      middleware_app.call(env)

      env.response
    end

    def middleware_app
      @app ||= begin
                 middleware_stack = middlewares

                 last_middleware = nil
                 middleware_stack.reverse.each do |middleware|
                   middleware.app = last_middleware
                   last_middleware = middleware
                 end

                 middleware_stack.first
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
      super || !!middleware_app.endpoint_for(name)
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
