require 'spec_helper'
require 'logger'

describe "A response to a request sent to the CloudStack API", :vcr do
  let(:io)         { StringIO.new }
  let(:logger)     { Logger.new(io) }
  let(:log_string) { io.string }
  let(:url)        { ENV["CLOUD_STACK_URL"] }
  let(:config_hash) do
    {
      url:        url,
      api_key:    ENV["CLOUD_STACK_API_KEY"],
      secret_key: ENV["CLOUD_STACK_SECRET_KEY"],
      logger:     logger,
      apis_path:  File.join(File.dirname(__FILE__), '../fixtures/4.2.json')
    }
  end
  let(:client) do
    StackerBee::Client.new(config_hash)
  end
  subject do
    client.list_accounts
  end

  it { should_not be_empty }
  its(:first) { should include "id" }

  it "should log request" do
    subject
    log_string.should include "listAccounts"
  end

  it "should not log response as error" do
    subject
    log_string.should_not include "ERROR"
  end

  context "containing an error" do
    subject do
      client.deploy_virtual_machine
    end
    it { expect(-> { subject }).to raise_error StackerBee::ClientError }

    it "should log response as error" do
      begin
        subject
      rescue StackerBee::ClientError
        log_string.should include "ERROR"
      end
    end
  end

  context "failing to connect" do
    let(:url) { "http://127.0.0.1:1234/client/api" }
    it "should raise helpful exception" do
      klass = StackerBee::ConnectionError
      expect(-> { subject }).to raise_error klass, /#{url}/
    end
  end

  context "trailing slash in URL" do
    let(:url) { ENV["CLOUD_STACK_URL"].gsub(/\/$/, '') + '/' }
    it "makes request with trailing slash" do
      stub = stub_request(:get, /#{url}/).to_return(body: '{"foo": {}}')
      subject
      stub.should have_been_requested
    end
  end
end
