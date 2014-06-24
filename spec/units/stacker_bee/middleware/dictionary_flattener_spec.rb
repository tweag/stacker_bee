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
    subject { described_class.new.params(params) }

    def param(number)
      described_class.tokenize "rebels[#{number}]"
    end

    let(:params) do
      { "time" => "long ago",
        "rebels" => {
          "r2"      => "d2",
          "blank"   => "",
          "falsey"  => "false",
          "false"   => false,
          "droid"   => true } }
    end

    it "flattens objects in the manner that cloudstack expects" do
      subject["#{param(0)}.name"].should eq "r2"
      subject["#{param(0)}.key"].should eq "r2"
      subject["#{param(0)}.value"].should eq "d2"
    end

    it "does not flatten empty hashes" do
      subject.should_not have_key "#{param(2)}.name"
    end

    it "handles true booleans" do
      subject["#{param(1)}.name"].should eq "droid"
      subject["#{param(1)}.value"].should be_true
    end

    it "removes original map params" do
      subject.should_not have_key "rebels"
    end

    it "doesnt send false to CloudStack" do
      # This assumption is based on CloudStack UI behavior
      subject.values.should_not include false
      subject.values.should_not include "false"
    end
  end
end
