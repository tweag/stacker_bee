require 'spec_helper'
require 'logger'

describe "A response to a request sent to the CloudStack API", :vcr do
  let(:io)         { StringIO.new }
  let(:logger)     { Logger.new(io) }
  let(:log_string) { io.string }
  let(:url)        { CONFIG["url"] }
  let(:config_hash) do
    {
      url:        url,
      api_key:    CONFIG["api_key"],
      secret_key: CONFIG["secret_key"],
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
    it { expect { subject }.to raise_error StackerBee::ClientError }

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

  context "trailing slash in URL", :regression do
    let(:url) { CONFIG["url"].gsub(/\/$/, '') + '/' }
    it "makes request with trailing slash" do
      stub = stub_request(:get, /#{url}/).to_return(body: '{"foo": {}}')
      subject
      stub.should have_been_requested
    end
  end

  context "space character in a request parameter", :regression do
    let(:params) { { name: "stacker bee" } }
    subject do
      client.list_accounts(params)
    end

    it "properly signs the request" do
      expect { subject }.not_to raise_error
    end
  end

  context "a nil request parameter", :regression do
    let(:params) { { name: nil } }
    subject do
      client.list_accounts(params)
    end

    it "properly executes the request" do
      expect { subject }.not_to raise_error
    end
  end

  context "a request parameter with and empty string", :regression do
    let(:params) { { name: '' } }
    subject do
      client.list_accounts(params)
    end

    it "properly executes the request" do
      expect { subject }.not_to raise_error
    end
  end

  context "a request parameter with an Array", :regression do
    let(:params) { { page: 1, pagesize: 1, details: %i(events stats) } }
    subject do
      client.list_hosts(params).first.keys
    end
    it { should include "cpuused" }
    it { should include "events" }
    it { should_not include "cpuallocated" }
  end
end
