require "spec_helper"

describe StackerBee::Connection do
  let(:url)           { "http://test.com:1234/foo/bar/" }
  let(:path)          { "/foo/bar" }
  let(:secret_key)    { "shhh" }
  let(:configuration) { double url: url, secret_key: secret_key }
  let(:query_params)  { [[:foo, :bar]] }
  let(:request)       { double query_params: query_params }
  let(:response)      { double }
  let(:faraday)       { double get: response }
  let(:connection)    { StackerBee::Connection.new configuration }
  subject(:get) { connection.get request, path }
  before do
    Faraday.stub(:new) { faraday }
  end

  context "successfully connecting" do
    before do
      faraday.should_receive(:get).with('/foo/bar', query_params) { response }
    end
    it { should be response }
    it "specifies url without path when creating connection" do
      get
      Faraday.should have_received(:new).with(url: "http://test.com:1234")
    end
  end

  context "failing to connect" do
    before do
      faraday.stub(:get) { fail Faraday::Error::ConnectionFailed, "boom" }
    end
    it "should raise helpful exception" do
      klass = StackerBee::ConnectionError
      expect { get }.to raise_error klass, /#{url}/
    end
  end

  context "no protocol specified in URL" do
    let(:url) { "wrong.com" }
    it "should raise helpful exception" do
      klass = StackerBee::ConnectionError
      expect { get }.to raise_error klass, /no protocol/
    end
  end

  context "when given a path" do
    let(:path) { '/baz' }
    it "makes a request to the correct path" do
      expect(faraday).to receive(:get).with(path, query_params)
      connection.get request, path
    end
  end
end
