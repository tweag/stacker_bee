module StackerBee
  class Configuration
    class NoAttributeError < StandardError
    end

    ATTRIBUTES = [
      :ssl_verify,
      :url,
      :secret_key,
      :api_key,
      :middlewares,
      :faraday_middlewares,
      :logger
    ]

    def initialize(attrs = nil)
      @attributes = attrs || {}
      @attributes.each_pair do |key, value|
        unless ATTRIBUTES.include?(key)
          fail NoAttributeError, "No attribute defined: '#{key}'"
        end
      end
    end

    def ssl_verify?
      attribute :ssl_verify, true
    end

    def url
      attribute :url
    end

    def secret_key
      attribute :secret_key
    end

    def api_key
      attribute :api_key
    end

    def middlewares
      attribute :middlewares, proc {}
    end

    def faraday_middlewares
      attribute :faraday_middlewares, proc {}
    end

    def logger
      attribute :logger
    end

    def to_hash
      @attributes
    end

    def merge(other)
      self.class.new(to_hash.merge(other.to_hash))
    end

    private

    def attribute(key, value = nil)
      @attributes.fetch(key, value)
    end
  end
end
