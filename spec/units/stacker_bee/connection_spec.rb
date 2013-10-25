require "spec_helper"

describe StackerBee::Connection do
  let(:url)           { "test.com" }
  let(:secret_key)    { "shhh" }
  let(:configuration) { double url: url, secret_key: secret_key }
  let(:query_params)  { [[:foo, :bar]] }
  let(:request)       { double query_params: query_params }
  let(:response)      { double }
  let(:faraday)       { double get: response }
  let(:connection)    { StackerBee::Connection.new configuration }
  before do
    Faraday.should_receive(:new).with(url: url) { faraday }
  end
  subject { connection.get request }

  context "successfully connecting" do
    before do
      faraday.should_receive(:get).with('', query_params) { response }
    end
    it { should be response }
  end

  context "failing to connect" do
    before do
      faraday.stub(:get) { fail Faraday::Error::ConnectionFailed, "boom" }
    end
    it "should raise helpful exception" do
      klass = StackerBee::ConnectionError
      expect(-> { subject }).to raise_error klass, /#{url}/
    end
  end
end
