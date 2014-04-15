require "spec_helper"

describe StackerBee::Configuration do
  describe "setting an attribute that doesn't exist" do
    [:ssl_verify?, :url?, :other_attr].each do |attr|
      it "raises an error" do
        expect { described_class.new(attr => true) }
          .to raise_error described_class::NoAttributeError, /#{attr}/
      end
    end
  end

  describe "#ssl_verify?" do
    subject { configuration.ssl_verify? }

    context "when not set" do
      let(:configuration) { described_class.new }
      it { should eq true }
    end

    context "when set to false" do
      let(:configuration) { described_class.new(ssl_verify: false) }
      it { should eq false }
    end

    context "when set to true" do
      let(:configuration) { described_class.new(ssl_verify: true) }
      it { should eq true }
    end
  end

  describe "#url" do
    subject { configuration.url }

    context "when not set" do
      let(:configuration) { described_class.new }
      it { should eq nil }
    end

    context "when set" do
      let(:configuration) { described_class.new(url: setting) }
      let(:setting) { "http://example.com" }
      it { should eq setting }
    end
  end

  describe "#secret_key" do
    subject { configuration.secret_key }

    context "when not set" do
      let(:configuration) { described_class.new }
      it { should eq nil }
    end

    context "when set" do
      let(:configuration) { described_class.new(secret_key: setting) }
      let(:setting) { "qwertyuiop" }
      it { should eq setting }
    end
  end

  describe "#api_key" do
    subject { configuration.api_key }

    context "when not set" do
      let(:configuration) { described_class.new }
      it { should eq nil }
    end

    context "when set" do
      let(:configuration) { described_class.new(api_key: setting) }
      let(:setting) { "qwertyuiop" }
      it { should eq setting }
    end
  end

  describe "#middlewares" do
    subject { configuration.middlewares }

    context "when not set" do
      let(:configuration) { described_class.new }
      it { should be_a Proc }
    end

    context "when set" do
      let(:configuration) { described_class.new(middlewares: setting) }
      let(:setting) { proc { something } }
      it { should eq setting }
    end
  end

  describe "#faraday_middlewares" do
    subject { configuration.faraday_middlewares }

    context "when not set" do
      let(:configuration) { described_class.new }
      it { should be_a Proc }
    end

    context "when set" do
      let(:configuration) { described_class.new(faraday_middlewares: setting) }
      let(:setting) { proc { something } }
      it { should eq setting }
    end
  end

  describe "#merge" do
    subject { parent.merge(child) }

    let(:parent) do
      described_class.new(
        url: :parent_url,
        api_key: :parent_api_key,
        secret_key: :parent_secret_key,
        ssl_verify: :parent_ssl_verify,
        middlewares: :parent_ssl_middlewares,
        faraday_middlewares: :parent_faraday_middlewares
      )
    end

    let(:child) do
      described_class.new(
        url: :child_url,
        api_key: :child_api_key,
        secret_key: :child_secret_key,
        ssl_verify: :child_ssl_verify,
        middlewares: :child_ssl_middlewares,
        faraday_middlewares: :child_faraday_middlewares
      )
    end

    context "when the child doesn't have an attribute set" do
      let(:child) { described_class.new }
      it "uses the attribute of the parent" do
        subject.url.should eq :parent_url
        subject.api_key.should eq :parent_api_key
        subject.secret_key.should eq :parent_secret_key
        subject.ssl_verify?.should eq :parent_ssl_verify
        subject.middlewares.should eq :parent_ssl_middlewares
        subject.faraday_middlewares.should eq :parent_faraday_middlewares
      end
    end

    context "when the parent doesn't have an attribute set" do
      let(:parent) { described_class.new }
      it "uses the attribute of the child" do
        subject.url.should eq :child_url
        subject.api_key.should eq :child_api_key
        subject.secret_key.should eq :child_secret_key
        subject.ssl_verify?.should eq :child_ssl_verify
        subject.middlewares.should eq :child_ssl_middlewares
        subject.faraday_middlewares.should eq :child_faraday_middlewares
      end
    end

    context "when the parent and child don't have an attribut set" do
      let(:child) { described_class.new }
      let(:parent) { described_class.new }
      it "uses the defaults of the attributes of the child" do
        subject.url.should eq nil
        subject.api_key.should eq nil
        subject.secret_key.should eq nil
        subject.ssl_verify?.should eq true
        subject.middlewares.should be_a Proc
        subject.faraday_middlewares.should be_a Proc
      end
    end
  end
end
