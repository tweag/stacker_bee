require 'spec_helper'

describe StackerBee::Middleware::DictionaryFlattener do
  let(:lb)               { described_class::LB }
  let(:rb)               { described_class::RB }
  let(:string)           { 'cool[0].name%21' }
  let(:tokenized_string) { "cool#{lb}0#{rb}.name%21" }

  describe '.detokenize' do
    subject { described_class.detokenize(tokenized_string) }
    it { is_expected.to eq string  }
  end

  describe '.tokenize' do
    subject { described_class.tokenize(string) }
    it { is_expected.to eq tokenized_string  }
  end

  describe '.new' do
    subject { described_class.new.transform_params(params) }

    def param(number)
      described_class.tokenize "rebels[#{number}]"
    end

    let(:params) do
      { 'time' => 'long ago',
        'rebels' => {
          'r2'      => 'd2',
          'blank'   => '',
          'falsey'  => 'false',
          'false'   => false,
          'droid'   => true } }
    end

    it 'flattens objects in the manner that cloudstack expects' do
      expect(subject["#{param(0)}.name"]).to eq 'r2'
      expect(subject["#{param(0)}.key"]).to eq 'r2'
      expect(subject["#{param(0)}.value"]).to eq 'd2'
    end

    it 'does not flatten empty hashes' do
      expect(subject).not_to have_key "#{param(2)}.name"
    end

    it 'handles true booleans' do
      expect(subject["#{param(1)}.name"]).to eq 'droid'
      expect(subject["#{param(1)}.value"]).to be true
    end

    it 'removes original map params' do
      expect(subject).not_to have_key 'rebels'
    end

    it 'doesnt send false to CloudStack' do
      # This assumption is based on CloudStack UI behavior
      expect(subject.values).not_to include false
      expect(subject.values).not_to include 'false'
    end
  end
end
