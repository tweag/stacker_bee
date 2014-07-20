require "spec_helper"

shared_examples_for "a Rash" do |mapping|
  mapping.each_pair { |key, value| its([key]) { should == value } }
end

describe StackerBee::Rash do
  subject { rash }

  let(:wiz) { [{ "aB_C" => "abc" }, { "X_yZ" => "xyz" }] }
  let(:ziz) do
    {
      "M-om" => {
        "kI_d" => 2
      }
    }
  end
  let(:hash) do
    {
      "foo"  => "foo",
      "b_iz" => "biz",
      "WiZ"  => wiz,
      :ziz   => ziz
    }
  end
  let(:similar_hash) do
    hash.dup.tap do |loud|
      value = loud.delete "foo"
      loud["FOO"] = value
    end
  end
  let(:dissimilar_hash) { hash.dup.tap { |loud| loud.delete "foo" } }
  let(:rash) { described_class.new(hash) }

  it { should include "FOO" }

  it { should == subject }
  it { should == subject.dup }
  it { should == hash }
  it { should == described_class.new(hash) }
  it { should == similar_hash }
  it { should_not == dissimilar_hash }

  it_behaves_like "a Rash",
                  "FOO"  => "foo",
                  :foo   => "foo",
                  "foo"  => "foo",
                  "f_oo" => "foo",
                  "BIZ"  => "biz",
                  :biz   => "biz",
                  "biz"  => "biz",
                  "b_iz" => "biz"

  context "enumerable value" do
    subject { rash["wiz"].first }
    it_behaves_like "a Rash", "ab_c" => "abc"
  end

  context "nested hash value" do
    subject { rash["ziz"] }
    it_behaves_like "a Rash", "mom" => { "kid" => 2 }

    context "deeply nested hash value" do
      subject { rash["ziz"]["mom"] }
      it_behaves_like "a Rash", "kid" => 2
    end
  end

  describe "#select" do
    subject { rash.select { |_, value| value.is_a? String } }
    it { should be_a described_class }
    it { should include "FOO" }
    it { should_not include "WIZ" }
  end

  describe "#reject" do
    subject { rash.reject { |_, value| value.is_a? String } }
    it { should be_a described_class }
    it { should include "WIZ" }
    it { should_not include "FOO" }
  end

  describe "#values_at" do
    subject { rash.values_at "FOO", "WIZ", "WRONG" }
    it { should == ["foo", wiz, nil] }
  end
end
