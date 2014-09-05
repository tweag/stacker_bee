describe StackerBee::Middleware::EndpointNormalizer do
  let(:middleware) { described_class.new(app: app, api: api) }
  let(:app) { double(:app) }

  let(:env) do
    StackerBee::Middleware::Environment.new(endpoint_name: endpoint_name)
  end

  context "when it doesn't match" do
    let(:api) { {} }
    let(:endpoint_name) { :some_endpoint }

    describe '#endpoint_name_for' do
      before { allow(app).to receive :endpoint_name_for, &:upcase }

      it 'delegates to its app' do
        expect(middleware.endpoint_name_for('some-name')).to eq 'SOME-NAME'
      end
    end

    describe '#before' do
      before { allow(app).to receive_messages endpoint_name_for: nil }

      it "doesn't set the endpoint to nil", :regression do
        middleware.before env
        expect(env.request.endpoint_name).to eq endpoint_name
      end
    end
  end

  context 'when it matches an endpoint'
end
