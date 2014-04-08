require "forwardable"
require "stacker_bee/builder"
require "stacker_bee/configuration"
require "stacker_bee/api"
require "stacker_bee/connection"
require "stacker_bee/middleware/environment"
require "stacker_bee/middleware/base"
require "stacker_bee/middleware/adapter"
require "stacker_bee/middleware/endpoint_normalizer"
require "stacker_bee/middleware/remove_empty_strings"
require "stacker_bee/middleware/cloud_stack_api"
require "stacker_bee/middleware/dictionary_flattener"
require "stacker_bee/middleware/remove_nils"
require "stacker_bee/middleware/format_keys"
require "stacker_bee/middleware/format_values"
require "stacker_bee/middleware/json_body"
require "stacker_bee/middleware/de_namespace"
require "stacker_bee/middleware/rashify_response"
require "stacker_bee/middleware/clean_response"
require "stacker_bee/middleware/raise_on_http_error"
require "stacker_bee/middleware/http_status"
require "stacker_bee/middleware/console_access"

# rubocop:disable ClassLength
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

    # rubocop:disable MethodLength
    def middlewares
      # request
      builder.use Middleware::ConsoleAccess

      builder.use Middleware::EndpointNormalizer, api: self.class.api
      builder.use Middleware::RemoveEmptyStrings
      builder.use Middleware::CloudStackAPI, api_key: configuration.api_key

      configuration.middlewares.call builder

      builder.use Middleware::DictionaryFlattener
      builder.use Middleware::RemoveNils
      builder.use Middleware::FormatKeys
      builder.use Middleware::FormatValues

      # response
      builder.use Middleware::RaiseOnHTTPError
      builder.use Middleware::HTTPStatus
      builder.use Middleware::CleanResponse
      builder.use Middleware::RashifyResponse
      builder.use Middleware::DeNamespace
      builder.use Middleware::JSONBody

      builder.use Middleware::Adapter, connection: connection

      builder.build
    end

    def builder
      @builder ||= Builder.new
    end

    class << self
      def reset!
        @api, @api_path, @default_config = nil
      end

      def default_config
        @default_config ||= {
          faraday_middlewares: proc {},
          middlewares:         proc {}
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

      env.response.body
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

    def method_missing(method_name, *args, &block)
      if respond_to_via_delegation?(method_name)
        request(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to?(method_name, include_private = false)
      super || respond_to_via_delegation?(method_name)
    end

    def respond_to_via_delegation?(method_name)
      !!middleware_app.endpoint_name_for(method_name)
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
