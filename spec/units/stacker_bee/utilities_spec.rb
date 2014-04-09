require "spec_helper"

describe StackerBee::Utilities, "#uncase" do
  include StackerBee::Utilities

  it { uncase("Foo Bar").should eq "foobar" }
  it { uncase("foo_bar").should eq "foobar" }
  it { uncase("foo-bar").should eq "foobar" }
  it { uncase("fooBar").should eq "foobar" }
  it { uncase("foo[0].Bar").should eq "foo[0].bar" }

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
  it { camel_case("foo[0].Bar", false).should eq "Foo[0].Bar" }

  describe "#map_a_hash" do
    let(:original) { { 1 =>  1, 2 =>  2 } }
    let(:expected) { { 2 => -1, 4 => -2 } }

    let(:transformed) do
      map_a_hash(original) { |key, value| [key * 2, value * -1] }
    end

    it "maps over a hash" do
      transformed.should eq expected
    end

    it "does not modify the original" do
      original.freeze
      transformed
    end
  end

  describe ".transform_hash_keys" do
    it { transform_hash_keys({ 1 => 2 }, &:odd?).should eq true => 2 }
  end

  describe ".transform_hash_values" do
    it { transform_hash_values({ 1 => 2 }, &:odd?).should eq 1 => false }
  end
end
