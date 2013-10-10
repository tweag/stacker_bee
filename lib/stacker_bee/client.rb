module StackerBee
  class Client
    attr_writer :url, :api_key, :secret_key

    def initialize(config = {})
      self.configuration = config
    end

    def configuration=(config)
      %w(url api_key secret_key).each do |param|
        value = config[param] || config[param.to_sym]
        self.send("#{param}=", value) if value
      end
      configuration
    end

    def configuration
      {
        url:        self.url,
        api_key:    self.api_key,
        secret_key: self.secret_key
      }
    end

    def url
      @url ||= self.class.url
    end

    def api_key
      @api_key ||= self.class.api_key
    end

    def secret_key
      @secret_key ||= self.class.secret_key
    end

    class << self
      attr_accessor :url, :api_key, :secret_key

      def configuration=(config)
        %w(url api_key secret_key).each do |param|
          value = config[param] || config[param.to_sym]
          self.send("#{param}=", value) if value
        end
        configuration
      end

      def configuration
        {
          url:        self.url,
          api_key:    self.api_key,
          secret_key: self.secret_key
        }
      end
    end
  end
end
