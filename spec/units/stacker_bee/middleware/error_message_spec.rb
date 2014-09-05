describe StackerBee::Middleware::ErrorMessage do
  subject { env.response }
  before { middleware.after(env) }

  let(:middleware) { described_class.new }
  let(:env) do
    StackerBee::Middleware::Environment.new.tap do |env|
      env.response.body    = body
      env.response.success = is_success?
    end
  end
  let(:body) { { errortext: message } }
  let(:message) { 'Unable to execute API command deployvirtualmachine ' }
  let(:is_success?) { true }

  it "doesn't apply to HTML responses" do
    expect(middleware.content_types).not_to match 'text/html; charset=utf-8'
  end
  it 'applies to JSON responses' do
    expect(middleware.content_types).to match 'text/javascript; charset=utf-8'
  end

  context 'given an error' do
    let(:is_success?) { false }
    its(:error) { should eq message }
  end

  context 'given a success' do
    let(:is_success?) { true }
    its(:error) { should be_nil }
  end
end
