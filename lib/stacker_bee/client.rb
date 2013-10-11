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

    def list_virtual_machines(options = {})
      self.request(:list_virtual_machines, options)
    end

    protected

    def request(endpoint, options = {})
      self.connection.get endpoint, options
    end

    def connection
      @connection ||= Connection.new(self.configuration)
    end
  end
end
