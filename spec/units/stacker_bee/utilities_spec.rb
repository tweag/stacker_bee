require 'spec_helper'

describe StackerBee::Utilities, '#uncase' do
  include StackerBee::Utilities

  it { expect(uncase('Foo Bar')).to eq 'foobar' }
  it { expect(uncase('foo_bar')).to eq 'foobar' }
  it { expect(uncase('foo-bar')).to eq 'foobar' }
  it { expect(uncase('fooBar')).to eq 'foobar' }
  it { expect(uncase('foo[0].Bar')).to eq 'foo[0].bar' }

  it { expect(snake_case('Foo Bar')).to eq 'foo_bar' }
  it { expect(snake_case('foo_bar')).to eq 'foo_bar' }
  it { expect(snake_case('foo-bar')).to eq 'foo_bar' }
  it { expect(snake_case('fooBar')).to eq 'foo_bar' }

  it { expect(camel_case('Foo Bar')).to eq 'FooBar' }
  it { expect(camel_case('foo_bar')).to eq 'FooBar' }
  it { expect(camel_case('foo-bar')).to eq 'FooBar' }
  it { expect(camel_case('fooBar')).to eq 'FooBar' }

  it { expect(camel_case('Foo Bar', true)).to eq 'fooBar' }
  it { expect(camel_case('foo_bar', true)).to eq 'fooBar' }
  it { expect(camel_case('foo-bar', true)).to eq 'fooBar' }
  it { expect(camel_case('fooBar', true)).to eq 'fooBar' }
  it { expect(camel_case('fooBar', false)).to eq 'FooBar' }
  it { expect(camel_case('foo[0].Bar', false)).to eq 'Foo[0].Bar' }

  describe '#map_a_hash' do
    let(:original) { { 1 =>  1, 2 =>  2 } }
    let(:expected) { { 2 => -1, 4 => -2 } }

    let(:transformed) do
      map_a_hash(original) { |key, value| [key * 2, value * -1] }
    end

    it 'maps over a hash' do
      expect(transformed).to eq expected
    end

    it 'does not modify the original' do
      original.freeze
      transformed
    end
  end

  describe '.transform_hash_keys' do
    it { expect(transform_hash_keys({ 1 => 2 }, &:odd?)).to eq true => 2 }
  end

  describe '.transform_hash_values' do
    it { expect(transform_hash_values({ 1 => 2 }, &:odd?)).to eq 1 => false }
  end
end
