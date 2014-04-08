require "spec_helper"

describe StackerBee::Middleware::Adapter do
  let(:env) do
    StackerBee::Middleware::Environment.new(
      endpoint_name: 'listVirtualMachines',
      params: params,
      path: path
    )
  end
  let(:app) { double(:app, call: response) }
  let(:response) { double(:response) }
  let(:path) { double(:path) }

  let(:params) { { 'z' => 'z', 'a' => 'a' } }
  let(:connection) { double(:connection, get: raw_response) }
  let(:middleware) { described_class.new(app: app, connection: connection) }

  let(:raw_response) do
    double(env: { response_headers: response_headers }, body: response_body)
  end
  let(:response_headers) { { "content-type" => content_type } }
  let(:content_type) { "text/javascript; charset=UTF-8"  }
  let(:response_body) { double }

  describe "#call" do
    before { middleware.call(env) }

    it "makes a call via the connection" do
      connection.should have_received(:get)
    end

    it "sets the environment's raw_response" do
      env.raw_response.should == raw_response
    end

    it "sets the response's mime type" do
      env.response.content_type.should == content_type
    end

    it "sets the response's body to the raw response's body" do
      env.response.body.should == response_body
    end

    it "sorts the paramers" do
      connection.should have_received(:get).with([%w(a a), %w(z z)], path)
    end
  end

  describe "#endpoint_name_for" do
    subject { middleware.endpoint_name_for('listVirtualMachines') }
    it { should be_nil }
  end
end
