require "forwardable"
require "stacker_bee/utilities"

module StackerBee
  class Rash
    extend Forwardable
    include Utilities

    def_delegators :@hash, *[
      :default, :default_proc, :each_value, :empty?, :has_value?, :hash,
      :length, :size, :value?, :values, :assoc, :each, :each_key, :each_pair,
      :flatten, :invert, :keys, :key, :merge, :rassoc, :to_a, :to_h, :to_hash
    ]

    def initialize(hash = {})
      @hash = {}
      hash.each_pair do |key, value|
        @hash[convert_key(key)] = convert_value(value)
      end
      @hash.freeze
    end

    def ==(other)
      case other
      when Rash
        super || @hash == other.to_hash
      when Hash
        self == Rash.new(other)
      else
        super
      end
    end

    def select(*args, &block)
      Rash.new @hash.select(*args, &block)
    end

    def reject(*args, &block)
      Rash.new @hash.reject(*args, &block)
    end

    def values_at(*keys)
      @hash.values_at(*keys.map { |key| convert_key(key) })
    end

    def fetch(key, *args, &block)
      @hash.fetch(convert_key(key), *args, &block)
    end

    def [](key)
      @hash[convert_key(key)]
    end

    def key?(key)
      @hash.key?(convert_key(key))
    end
    alias_method :include?, :key?
    alias_method :has_key?, :key?
    alias_method :member?,  :key?

    def to_hash
      self.class.deep_dup(@hash)
    end

    def inspect
      "#<#{self.class} #{@hash}>"
    end
    alias_method :to_s, :inspect

    protected

    def self.deep_dup(hash)
      hash.dup.tap do |duplicate|
        duplicate.each_pair do |key, value|
          duplicate[key] = deep_dup(value) if value.is_a?(Hash)
        end
      end
    end

    def convert_key(key)
      key.kind_of?(Numeric) ? key : uncase(key)
    end

    def convert_value(value)
      case value
      when Hash
        Rash.new(value)
      when Array
        value.map { |item| convert_value(item) }
      else
        value
      end
    end
  end
end
