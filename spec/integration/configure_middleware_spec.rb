require 'spec_helper'

describe "Configuring middlewares" do
  let(:configuration) do
    {
      url:                 "http://garbagestring",
      api_key:             "HI!",
      secret_key:          "SECRET",
      faraday_middlewares: faraday_middlewares,
      middlewares:         middlewares
    }
  end

  let(:faraday_middlewares) { proc {} }
  let(:middlewares)         { proc {} }

  let(:middleware_class) { Class.new(StackerBee::Middleware::Base, &body) }
  let(:faraday_middleware_class) { Class.new(Faraday::Middleware, &body) }

  let(:body) do
    proc do
      def call(_env)
        fail "MiddlewareUsed"
      end
    end
  end

  def self.it_uses_the_middleware
    it "uses the middle ware" do
      expect { subject.list_virtual_machines }
        .to raise_exception "MiddlewareUsed"
    end
  end

  def self.it_configures_a_faraday_middleware
    describe "a Faraday middleware" do
      let(:faraday_middlewares) do
        ->(faraday) { faraday.use faraday_middleware_class }
      end

      it_uses_the_middleware
    end
  end

  def self.it_configures_a_middleware
    describe "a StackerBee middleware" do
      let(:middlewares) do
        ->(builder) { builder.use middleware_class }
      end
      it_uses_the_middleware
    end
  end

  describe "via StackerBee::Client.configuration=" do
    subject { StackerBee::Client.new }
    before  { StackerBee::Client.configuration = configuration }

    it_configures_a_middleware
    it_configures_a_faraday_middleware
  end

  describe "via the Client initializer" do
    subject { StackerBee::Client.new(configuration) }

    it_configures_a_middleware
    it_configures_a_faraday_middleware
  end
end
