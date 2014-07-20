require 'spec_helper'

describe StackerBee::Middleware::ConsoleAccess do
  let(:env) do
    StackerBee::Middleware::Environment.new(endpoint_name: endpoint_name)
  end

  let(:middleware) { described_class.new(app: app) }
  let(:app) { double(:app) }

  context 'when it matches the endpoint' do
    let(:endpoint_name) { described_class::ENDPOINT }

    it 'adds its path to the env' do
      middleware.before(env)
      expect(env.request.path).to eq described_class::PATH
    end

    it 'adds cmd to the parameters' do
      expect(env.request.params).not_to include described_class::PARAMS
    end
  end

  context "when it doesn't match the endpoint" do
    let(:endpoint_name) { :other_endpoint }

    before { middleware.before(env) }

    it "doesn't add it's path" do
      expect(env.request.path).not_to eq described_class::PATH
    end

    it "doesn't add cmd to the parameters" do
      expect(env.request.params).not_to include described_class::PARAMS
    end
  end

  it 'matches html content typtes' do
    expect(middleware.content_types).to match 'text/html; charset=utf-8'
  end

  describe '#endpoint_name_for' do
    context 'given names it reponds to' do
      %w(consoleAccess console_access CONSOLEACCESS).each do |name|
        subject { middleware.endpoint_name_for(name) }
        it { is_expected.to eq described_class::ENDPOINT }
      end
    end

    context 'for other names' do
      before { allow(app).to receive :endpoint_name_for, &:upcase }

      it 'delegates for other names' do
        expect(middleware.endpoint_name_for('other-name')).to eq 'OTHER-NAME'
      end
    end
  end
end
