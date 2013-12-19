require "spec_helper"
require "logger"

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

  subject { client.list_accounts }

  it { should_not be_empty }

  context "first item" do
    subject { client.list_accounts.first }
    it { should include "id" }
    its(["accounttype"])  { should be_a Numeric }
    its(["account_type"]) { should be_a Numeric }
  end

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
    let(:params) { { page: 1, pagesize: 1, details: [:events, :stats] } }
    subject do
      client.list_hosts(params).first.keys
    end
    it { should include "cpuused" }
    it { should include "events" }
    it { should_not include "cpuallocated" }
  end

  context "a request parameter with a map" do
    let(:zone_id)             { client.list_zones.first["id"] }

    let(:service_offering_id) do
      client.list_network_offerings(
        supported_services: 'sourcenat',
        type: 'isolated').first["id"]
    end

    let(:network) do
      client.create_network(zone_id: zone_id,
                            network_offering_id: service_offering_id,
                            name: "John", displaytext: "John")
    end

    let(:tag) do
      client.create_tags(resource_type: "Network",
                         resource_ids: network["id"],
                         tags: { "speed [lab]" => 'real fast!' })
    end

    it "can create an object" do
      tag.should_not be_nil
    end
  end
end
