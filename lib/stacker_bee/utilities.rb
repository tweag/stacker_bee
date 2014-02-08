module StackerBee
  module Utilities
    REGEX = /\s|-|_/

    module_function

    def uncase(string)
      string.to_s.downcase.gsub(REGEX, '')
    end

    def snake_case(string)
      string.to_s.gsub(/(.)([A-Z])/, '\1_\2').gsub(/(\W|_)+/, '_').downcase
    end

    # TODO: avoid flag arguments
    def camel_case(string, lower = false)
      string.to_s.split(REGEX).each_with_object('') do |word, memo|
        memo << (memo.empty? && lower ? word[0].downcase : word[0].upcase)
        memo << word[1..-1]
      end
    end

    def hash_deeply(hash, &block)
      block.call hash

      hash.values
        .select { |val| val.respond_to?(:to_hash) }
        .each   { |val| hash_deeply val, &block }
    end

    def map_a_hash(hash)
      hash.each_with_object({}) do |pair, new_hash|
        key, value = yield(*pair)
        new_hash[key] = value
      end
    end

    def transform_hash_values(hash)
      map_a_hash(hash) do |key, val|
        [key, yield(val)]
      end
    end

    def transform_hash_keys(hash)
      map_a_hash(hash) do |key, val|
        [yield(key), val]
      end
    end
  end
end
