require 'spec_helper'

describe StackerBee::Middleware::DictionaryFlattener do
  let(:lb)               { described_class::LB }
  let(:rb)               { described_class::RB }
  let(:string)           { "cool[0].name%21" }
  let(:tokenized_string) { "cool#{lb}0#{rb}.name%21" }

  describe ".detokenize" do
    subject { described_class.detokenize(tokenized_string) }
    it { should eq string  }
  end

  describe ".tokenize" do
    subject { described_class.tokenize(string) }
    it { should eq tokenized_string  }
  end

  describe ".new" do
    def prefix(number)
      described_class.tokenize "rebels[#{number}]"
    end

    let(:params) do
      { "time" => "long ago",
        "rebels" => { "r2" => "d2", "r1" => "", "father" => false } }
    end

    subject do
      described_class.new.params(params)
    end

    it "flattens objects in the manner that cloudstack expects" do
      subject["#{prefix(0)}.name"].should eq "r2"
      subject["#{prefix(0)}.key"].should eq "r2"
      subject["#{prefix(0)}.value"].should eq "d2"
    end

    it "doesnt flatten empty hashes" do
      subject.should_not have_key "#{prefix(2)}.name"
    end

    it "handles booleans" do
      subject["#{prefix(1)}.name"].should eq "father"
    end

    it "removes original map params" do
      subject.should_not have_key "rebels"
    end
  end
end
