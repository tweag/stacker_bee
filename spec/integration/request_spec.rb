require 'spec_helper'

describe "A response to a request sent to the CloudStack API" do
  let(:config_hash) do
    {
      url:        ENV["CLOUD_STACK_URL"],
      api_key:    ENV["CLOUD_STACK_API_KEY"],
      secret_key: ENV["CLOUD_STACK_SECRET_KEY"],
    }
  end
  let(:client) {
    StackerBee::Client.new(config_hash) }
  subject { client.request :list_virtual_machines }
  it { should_not be_empty }
  its(:keys) { should include "listvirtualmachinesresponse" }
end
