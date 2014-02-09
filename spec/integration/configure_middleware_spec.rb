require 'spec_helper'

describe "Client initialization configures the middleware" do
  context "pass a new middleware to the client" do
    subject { StackerBee::Client.new(configuration) }

    let(:configuration) do
      {
        url:        "http://garbagestring",
        api_key:    "HI!",
        secret_key: "SECRET",
        middlewares: middleware_class.new
      }
    end

    let(:middleware_class) do
      Class.new(StackerBee::Middleware::Base) do
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

