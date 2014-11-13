describe StackerBee::Middleware::RashifyResponse do
  describe 'after' do
    let(:env) do
      StackerBee::Middleware::Environment.new.tap do |env|
        env.response.body = body
      end
    end

    before do
      subject.after(env)
    end

    context 'when the body is a hash' do
      let(:body) { { thedata: 'the data' } }

      it 'transforms the body into a Rash' do
        expect(env.response.body['the_data']).to eq 'the data'
      end
    end

    context 'when the body is an array' do
      let(:body) { [{ thedata: 'the data' }] }

      it "transforms the array's items Rashes" do
        expect(env.response.body.first['the_data']).to eq 'the data'
      end
    end

    context 'when the body is something else' do
      let(:body) { 'the data' }

      it 'does not modify the body' do
        expect(env.response.body).to eq 'the data'
      end
    end

    context 'with preferred keys' do
      subject { described_class.new(preferred_keys: %w(the_data)) }

      context 'when the body is a hash' do
        let(:body) { { thedata: 'the data' } }

        it 'transforms the body into a Rash with the preferred keys' do
          expect(env.response.body.keys).to eq ['the_data']
        end
      end

      context 'when the body is an array' do
        let(:body) { [{ thedata: 'the data' }] }

        it "transforms the array's items Rashes with the preferred keys" do
          expect(env.response.body.first.keys).to eq ['the_data']
        end
      end
    end
  end
end
