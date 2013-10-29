require "spec_helper"

describe StackerBee::Utilities, "#uncase" do
  include StackerBee::Utilities
  it { uncase("Foo Bar").should eq "foobar" }
  it { uncase("foo_bar").should eq "foobar" }
  it { uncase("foo-bar").should eq "foobar" }
  it { uncase("fooBar").should eq "foobar" }

  it { snake_case("Foo Bar").should eq "foo_bar" }
  it { snake_case("foo_bar").should eq "foo_bar" }
  it { snake_case("foo-bar").should eq "foo_bar" }
  it { snake_case("fooBar").should eq "foo_bar" }

  it { camel_case("Foo Bar").should eq "FooBar" }
  it { camel_case("foo_bar").should eq "FooBar" }
  it { camel_case("foo-bar").should eq "FooBar" }
  it { camel_case("fooBar").should eq "FooBar" }

  it { camel_case("Foo Bar", true).should eq "fooBar" }
  it { camel_case("foo_bar", true).should eq "fooBar" }
  it { camel_case("foo-bar", true).should eq "fooBar" }
  it { camel_case("fooBar", true).should eq "fooBar" }
  it { camel_case("fooBar", false).should eq "FooBar" }
end
