require 'spec_helper'

describe StackerBee::Connection do
  subject(:get) { connection.get(path, query_params) }
  before { allow(Faraday).to receive_messages new: faraday }

  let(:url)          { 'http://test.com:1234/foo/bar/' }
  let(:path)         { '/foo/bar' }
  let(:secret_key)   { 'shhh' }
  let(:query_params) { [[:foo, :bar]] }
  let(:response)     { double(:response) }
  let(:faraday)      { double(:faraday, get: response) }
  let(:connection)   { described_class.new(configuration) }
  let(:ssl_verify)   { true }
  let(:configuration) do
    StackerBee::Configuration.new(
      url:        url,
      secret_key: secret_key,
      ssl_verify: ssl_verify
    )
  end

  context 'successfully connecting' do
    before do
      expect(faraday).to receive(:get).with('/foo/bar', query_params) do
        response
      end
    end

    it { is_expected.to be response }

    it 'specifies url without path when creating connection' do
      get
      expect(Faraday).to have_received(:new).with(url: 'http://test.com:1234',
                                                  ssl: { verify: true })
    end
  end

  context 'failing to connect' do
    before do
      allow(faraday).to receive(:get) do
        fail Faraday::Error::ConnectionFailed, 'boom'
      end
    end

    it 'raises a helpful exception' do
      expect { get }.to raise_error StackerBee::ConnectionError, /#{url}/
    end
  end

  context 'no protocol specified in URL' do
    let(:url) { 'wrong.com' }
    it 'raises a helpful exception' do
      expect { get }.to raise_error StackerBee::ConnectionError, /no protocol/
    end
  end

  context 'when given a path' do
    let(:path) { '/baz' }
    it 'makes a request to the correct path' do
      expect(faraday).to receive(:get).with(query_params, path)
      connection.get query_params, path
    end
  end

  context 'when verifying an ssl connection' do
    let(:ssl_verify) { false }
    it 'specifies the ssl verify option when creating a connection' do
      get
      expect(Faraday).to have_received(:new).with(url: 'http://test.com:1234',
                                                  ssl: { verify: false })
    end
  end
end
