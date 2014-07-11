require 'spec_helper'

describe StackerBee::Middleware::FormatKeys do
  subject { described_class.new.transform_params(params) }

  let(:params) do
    {
      symbol:   true,
      key_case: true
    }
  end

  it { should have_key "symbol" }
  it { should_not have_key :symbol  }

  it { should have_key "keyCase" }
  it { should_not have_key :key_case }
end
