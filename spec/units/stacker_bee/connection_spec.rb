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
    faraday.should_receive(:get).with('', query_params) { response }
  end
  subject { connection.get request }
  it { should be response }
end
