require "spec_helper"

describe "A request sent to CloudStack for console access", :vcr do
  let(:config_hash) do
    {
      url:        CONFIG['url'],
      api_key:    CONFIG['api_key'],
      secret_key: CONFIG['secret_key']
    }
  end

  let(:client) do
    StackerBee::Client.new(config_hash)
  end

  let(:vm) { "36f9c08b-f17a-4d0e-ac9b-d45ce2d34fcd" }

  subject(:console_access) { client.console_access(vm: vm) }

  it "returns html for console access" do
    expect(console_access).to match %r{<html>.*<frame src=.*</html>}
  end
end
