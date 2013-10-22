require 'spec_helper'

describe "A response to a request sent to the CloudStack API", :vcr do
  let(:config_hash) do
    {
      url:        ENV["CLOUD_STACK_URL"],
      api_key:    ENV["CLOUD_STACK_API_KEY"],
      secret_key: ENV["CLOUD_STACK_SECRET_KEY"],
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

  context "containing an error" do
    subject do
      client.deploy_virtual_machine
    end
    it { expect(-> { subject }).to raise_error StackerBee::ClientError }
  end
end
