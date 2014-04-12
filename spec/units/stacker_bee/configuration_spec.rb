require "spec_helper"

describe StackerBee::Configuration do
  its(:url)        { should be_nil }
  its(:api_key)    { should be_nil }
  its(:secret_key) { should be_nil }

  describe "#ssl_verify?" do
    subject { configuration.ssl_verify? }
    let(:configuration) { described_class.new(ssl_verify: ssl_verify) }

    context "when nil" do
      let(:ssl_verify) { nil }
      it { should eq true }
    end
    context "when false" do
      let(:ssl_verify) { false }
      it { should eq false }
    end
    context "when true" do
      let(:ssl_verify) { true }
      it { should eq true }
    end
  end
end
