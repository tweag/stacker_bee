require "spec_helper"

describe StackerBee::Connection do
  let(:url)           { "http://test.com:1234/foo/bar/" }
  let(:secret_key)    { "shhh" }
  let(:configuration) { double url: url, secret_key: secret_key }
  let(:query_params)  { [[:foo, :bar]] }
  let(:request)       { double query_params: query_params }
  let(:response)      { double }
  let(:faraday)       { double get: response, adapter: nil }
  let(:connection)    { StackerBee::Connection.new configuration }
  before do
    Faraday.stub(:new) { faraday }
  end

  describe "#initialize_connection" do
    let(:middleware_logging_class) { double }
    let(:logger)                   { double }
    let(:adapter)                  { double }
    let(:configuration) { double url: url,
                          secret_key: secret_key,
                          middleware_logger: middleware_logging_class,
                          logger: logger,
                          adapter: adapter }
    subject { connection }

    before do
      Faraday.stub(:new) { faraday }.and_yield( faraday )
      faraday.stub(:use)
    end
    it "should use the provided middleware_logging class" do
      subject
      faraday.should have_received(:use).with(middleware_logging_class, logger)
    end
  end

  describe "#get" do
    subject { connection.get request }
    context "successfully connecting" do
      before do
        faraday.should_receive(:get).with('/foo/bar/', query_params) { response }
      end
      it { should be response }
      it "specifies url without path when creating connection" do
        subject
        Faraday.should have_received(:new).with(url: "http://test.com:1234")
      end
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

    context "no protocol specified in URL" do
      let(:url) { "wrong.com" }
      it "should raise helpful exception" do
        klass = StackerBee::ConnectionError
        expect(-> { subject }).to raise_error klass, /no protocol/
      end
    end
  end
end
