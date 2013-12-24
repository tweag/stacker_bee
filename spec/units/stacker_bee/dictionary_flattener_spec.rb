require 'spec_helper'

describe StackerBee::DictionaryFlattener do
  let(:lb)               { StackerBee::DictionaryFlattener::LB }
  let(:rb)               { StackerBee::DictionaryFlattener::RB }
  let(:string)           { "cool[0].name%21" }
  let(:tokenized_string) { "cool#{lb}0#{rb}.name%21" }

  describe ".detokenize" do
    subject { StackerBee::DictionaryFlattener.detokenize(tokenized_string) }
    it { should eq string  }
  end

  describe ".tokenize" do
    subject { StackerBee::DictionaryFlattener.tokenize(string) }
    it { should eq tokenized_string  }
  end

  describe ".new" do
    def prefix(number)
      StackerBee::DictionaryFlattener.tokenize "rebels[#{number}]"
    end

    let(:params) do
      { "time" => "long ago",
        "rebels" => { "r2" => "d2", "r1" => "", "father" => false } }
    end

    subject do
      StackerBee::DictionaryFlattener.new(params).params
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
