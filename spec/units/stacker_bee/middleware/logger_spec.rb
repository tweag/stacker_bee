require "spec_helper"

describe StackerBee::Middleware::Logger do
  let(:app)        { double }
  let(:io)         { StringIO.new }
  let(:logger)     { Logger.new(io) }
  let(:log_string) { io.string }
  let(:middleware) { described_class.new app, logger }
  subject { middleware }

  context "with a no logger specified" do
    let(:middleware) { described_class.new app, nil }
    its(:logger) { should be_a Logger }
  end

  describe "logging request" do
    let(:env) do
      {
        method:          "PATCH",
        url:             "http://localhost",
        request_headers: { "User-Agent" => "RSpec" }
      }
    end
    before do
      middleware.log_request(env)
    end
    subject { log_string }
    it { should include "PATCH" }
    it { should include "localhost" }
    it { should include "User-Agent" }
  end

  describe "logging a response" do
    let(:status) { 200 }
    let(:env) do
      {
        status:           status,
        body:             "OK",
        response_headers: { "Server" => "RSpec" }
      }
    end
    before do
      middleware.log_response(env)
    end
    subject { log_string }
    it { should =~ /INFO.*#{status}/ }
    it { should include "OK" }
    it { should include "Server" }

    context "failing status" do
      let(:status) { 401 }
      it { should =~ /ERROR.*#{status}/ }
    end
  end
end
