require 'spec_helper'

describe StackerBee::Middleware::EndpointNormalizer do
  let(:middleware) { described_class.new(app: app, api: api) }
  let(:app) { double(:app) }

  let(:env) do
    StackerBee::Middleware::Environment.new(endpoint_name: endpoint_name)
  end

  context "when it doesn't match" do
    let(:api) { {} }
    let(:endpoint_name) { :some_endpoint }

    describe "#endpoint_name_for" do
      before { app.stub :endpoint_name_for, &:upcase }

      it "delegates to its app" do
        middleware.endpoint_name_for('some-name').should == 'SOME-NAME'
      end
    end

    describe "#before" do
      before { app.stub endpoint_name_for: nil }

      it "doesn't set the endpoint to nil", :regression do
        middleware.before env
        env.request.endpoint_name.should == endpoint_name
      end
    end
  end

  context "when it matches an endpoint"
end
