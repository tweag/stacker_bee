if false
require 'spec_helper'

describe "Client initialization configures the middleware" do
  context "pass a new middleware to the client" do
    subject { StackerBee::Client.new(config_hash) }

    let(:url) { CONFIG["url"] }
    let(:config_hash) do
      {
        url:        url,
        api_key:    api_key,
        secret_key: secret_key,
        apis_path:  File.join(File.dirname(__FILE__), '../fixtures/4.2.json'),
        faraday_middlewares: ->(faraday) { faraday.use middleware_class }
      }
    end

    let(:middleware_class) do
      Class.new(Faraday::Middleware) do
        def call(env)
          $query = env[:url].query
          fail "MiddlewareUsed"
        end
      end
    end

    before do
      $query = nil
    end

    data = JSON.parse(File.read("/Users/mike/Desktop/stuff.json"))
    data.each do |request|
      context "something" do
        let(:api_key)    { request["config"]["api_key"] }
        let(:secret_key) { request["config"]["secret_key"] }
        it do
          expect {
            subject.request(*request["input"])
          }.to raise_exception "MiddlewareUsed"

          $query.should == request["query"]
        end
      end
    end
  end
end
end
