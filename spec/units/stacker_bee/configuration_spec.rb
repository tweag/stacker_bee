require "spec_helper"

describe StackerBee::Configuration do
  its(:url)         { should be_nil }
  its(:api_key)     { should be_nil }
  its(:secret_key)  { should be_nil }
end
