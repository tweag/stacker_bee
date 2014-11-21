describe StackerBee::Middleware::CloudStackAPI do
  let(:env) do
    StackerBee::Middleware::Environment.new(
      endpoint_name: 'endpoint-name'
    )
  end
  let(:middleware) { described_class.new(api_key: 'API-KEY', url: url) }
  let(:url) { 'http://localhost:1234/my/path' }

  before do
    middleware.before(env)
  end

  describe 'request' do
    subject { env.request }

    its(:path) { should == '/my/path' }
  end

  describe 'params' do
    subject { env.request.params }
    its([:api_key])  { should eq 'API-KEY' }
    its([:response]) { should eq 'json' }
    its([:command])  { should eq 'endpoint-name' }
  end
end
