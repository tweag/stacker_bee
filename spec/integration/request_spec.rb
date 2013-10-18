require 'spec_helper'

describe "A response to a request sent to the CloudStack API" do
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
  subject { client.list_accounts }
  it { should_not be_empty }
  its(:first) { should include "id" }

  context "containing an error" do
    subject { client.deploy_virtual_machine }
    it { expect(-> { subject }).to raise_error StackerBee::ClientError }
  end
end
