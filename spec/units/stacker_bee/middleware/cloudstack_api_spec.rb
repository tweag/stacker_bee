require 'spec_helper'

describe StackerBee::Middleware::CloudStackAPI do
  let(:env) do
    StackerBee::Middleware::Environment.new(
      endpoint_name: 'endpoint-name',
      path: path
    )
  end

  let(:middleware) { described_class.new(api_key: "API-KEY", params: {}) }
  let(:path) { nil }

  before { middleware.before(env) }

  describe "request" do
    subject { env.request }

    context "when the path is not set" do
      let(:path) { nil }
      its(:path) { should == described_class::DEFAULT_PATH }
    end

    context "when the path is already set" do
      let(:path) { "already set"  }
      its(:path) { should == path }
    end
  end

  describe "params" do
    subject { env.request.params }
    its([:api_key])  { should eq "API-KEY" }
    its([:response]) { should eq "json" }
    its([:command])  { should eq "endpoint-name" }
  end
end
