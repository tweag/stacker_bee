require 'spec_helper'

describe StackerBee::HTTPMiddleware::Graylog do
  subject { log_data }

  class DummyLogger
    attr_accessor :data
    alias_method :notify, :data=
  end

  let(:log_data) { logger.data }
  let(:logger)   { DummyLogger.new }

  let(:dummy_adapter) { ->(env) { Faraday::Response.new(env) } }
  let(:middleware) { described_class.new(dummy_adapter, logger) }
  let(:status) { 200 }

  let(:env) do
    {
      body: "DATA",
      response_headers: {},
      response: {},
      status: status,
      url: URI.parse("http://a.b/?key=KEY&command=listVirtualMachines&val=val")
    }
  end

  before { middleware.call(env) }

  it "sets a custom short message" do
    log_data[:short_message].should eq "StackerBee listVirtualMachines"
  end

  its([:facility]) { should == "stacker-bee" }

  context "without a command in the url" do
    let(:env) do
      {
        body: "DATA",
        response_headers: {},
        response: {},
        status: status,
        url: URI.parse("http://a.b/?key=KEY&&val=val")
      }
    end

    it "sets a custom short message" do
      log_data[:short_message].should eq "StackerBee"
    end
  end
end
