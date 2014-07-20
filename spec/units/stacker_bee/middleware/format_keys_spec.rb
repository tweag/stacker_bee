require 'spec_helper'

describe StackerBee::Middleware::FormatKeys do
  subject { described_class.new.transform_params(params) }

  let(:params) do
    {
      symbol:   true,
      key_case: true
    }
  end

  it { is_expected.to have_key 'symbol' }
  it { is_expected.not_to have_key :symbol  }

  it { is_expected.to have_key 'keyCase' }
  it { is_expected.not_to have_key :key_case }
end
