require 'spec_helper'

describe StackerBee, 'VERSION' do
  subject { StackerBee::VERSION }
  it { should_not be_nil }
end
