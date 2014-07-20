require 'spec_helper'

describe StackerBee, 'VERSION' do
  subject { StackerBee::VERSION }
  it { is_expected.not_to be_nil }
end
