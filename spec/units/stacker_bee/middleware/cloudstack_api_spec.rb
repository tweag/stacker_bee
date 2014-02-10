require 'spec_helper'

describe StackerBee::Middleware::CloudStackAPI do
  subject { env.request.params }

  let(:env) do
    StackerBee::Middleware::Environment.new(endpoint_name: 'endpoint-name')
  end

  let(:middleware) { described_class.new(api_key: "API-KEY", params: {}) }

  before { middleware.before(env) }

  its([:api_key])  { should eq "API-KEY" }
  its([:response]) { should eq "json" }
  its([:command])  { should eq "endpoint-name" }
end

