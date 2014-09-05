describe 'A request sent to CloudStack for console access', :vcr do
  subject(:console_access) { client.console_access(vm: vm) }

  let(:vm) { '36f9c08b-f17a-4d0e-ac9b-d45ce2d34fcd' }
  let(:client) { StackerBee::Client.new(config_hash) }
  let(:config_hash) do
    {
      url:        CONFIG['url'],
      api_key:    CONFIG['api_key'],
      secret_key: CONFIG['secret_key']
    }
  end

  it 'returns html for console access' do
    expect(console_access).to match(/<html>.*<frame src=.*<\/html>/)
  end
end
