require 'spec_helper'

describe StackerBee::Middleware::FormatValues do
  subject { described_class.new.params(params) }

  let(:params) do
    {
      single: 1,
      list:  [1,2,3]
    }
  end

  its([:single]) { should eq "1" }
  its([:list])   { should eq "1,2,3" }
end
