require 'spec_helper'

describe "Client initialization configures the middleware" do

  context "pass a new middleware to the client" do
    subject { StackerBee::Client.new(configuration) }

    let(:configuration) do
      {
        url:         "http://garbagestring",
        api_key:     "HI!",
        secret_key:  "SECRETT",
        middlewares: ->(faraday) { faraday.use middleware_class }
      }
    end

    let(:middleware_class) do
      Class.new(Faraday::Middleware) do
        def call(env)
          fail "MiddlewareUsed"
        end
      end
    end

    it "uses the middle ware" do
      expect { subject.list_virtual_machines }
        .to raise_exception "MiddlewareUsed"
    end
  end
end
