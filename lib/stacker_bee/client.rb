require "forwardable"

module StackerBee
  module Configurable
    extend Forwardable
    def_delegators :configuration, :url, :url=, :api_key, :api_key=, :secret_key, :secret_key=

    def configuration=(config)
      @configuration = Configuration.new(config)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Client
    include Configurable

    class << self
      include Configurable
    end

    def initialize(config = nil)
      config ||= self.class.configuration.dup
      self.configuration = config
    end

    def request(endpoint, params = {})
      request      = Request.new(endpoint, self.api_key, params) 
      raw_response = self.connection.get(request)
      Response.new(raw_response)
    end

    protected

    def connection
      @connection ||= Connection.new(self.configuration)
    end
  end
end
