require 'spec_helper'

describe FaradayMiddleware::Graylog do
  subject { log_data }

  class DummyLogger
    attr_accessor :data
    alias_method :notify, :data=
  end

  let(:log_data) { logger.data }
  let(:logger)   { DummyLogger.new }

  let(:dummy_adapter) { ->(env){ Faraday::Response.new(env) } }
  let(:middleware) do
    described_class.new(dummy_adapter, logger, facility: facility)
  end

  let(:env) do
    {
      body: "DATA",
      response_headers: {},
      response: {},
      status: status
    }
  end
  let(:facility) { nil }

  before { middleware.call(env) }

  context "a basic request" do
    let(:status) { 200 }

    its([:facility]) { should eq "faraday-middleware-graylog" }
    its([:short_message]) { should eq "faraday-middleware-graylog Request" }
    its([:_data]) do
      should eq(body: "DATA", response_headers: {}, status: status)
    end
  end

  context "given a facility" do
    let(:status) { 200 }
    let(:facility) { "stacker_bee" }

    its([:facility]) { should eq "stacker_bee" }
  end

  context "a successful request" do
    let(:status) { 200 }
    its([:level]) { should eq FaradayMiddleware::Graylog::INFO }
  end

  context "a failed request" do
    let(:status) { 500 }
    its([:level]) { should eq FaradayMiddleware::Graylog::ERROR }
  end

  describe "a subclass" do
    class GrayLogSubclass < FaradayMiddleware::Graylog
      def short_message(env)
        "Short message: #{env[:status]}"
      end

      def level(env)
        env[:status]
      end
    end

    let(:middleware) { GrayLogSubclass.new(dummy_adapter, logger) }
    let(:status) { 401 }

    it "can override the level determining logic" do
      log_data[:level].should eq 401
    end

    it "can override the short_message logic" do
      log_data[:short_message].should eq "Short message: 401"
    end
  end
end
