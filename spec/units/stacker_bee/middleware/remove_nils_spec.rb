require 'spec_helper'

describe StackerBee::Middleware::RemoveNils do
  it "removes pairs with nil values from the params" do
    subject.params(something: 'something', nothing: nil)
      .should eq something: 'something'
  end
end
