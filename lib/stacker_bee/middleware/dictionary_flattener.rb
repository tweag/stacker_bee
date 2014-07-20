module StackerBee
  module Middleware
    class DictionaryFlattener < Base
      LB = 'SBLEFTBRACKET'
      RB = 'SBRIGHTBRACKET'

      # TODO: should the tokenizing be separate from the flattener?
      # it could be a middleware that finds [] in the keys and replaces them
      def self.tokenize(key)
        key.gsub('[', LB).gsub(']', RB)
      end

      def self.detokenize(key)
        key.gsub(LB, '[').gsub(RB, ']')
      end

      def transform_params(original)
        original.dup.tap { |params| flatten_params(params) }
      end

      def flatten_params(params)
        hashes = params.select { |_, val| val.respond_to?(:keys) }
        flatten_map_values params, hashes
      end

      def flatten_map_values(params, hashes)
        hashes.each do |hash_name, hash|
          remove_falseish(hash).each_with_index do |(key, value), index|
            hash_url_key = self.class.tokenize("#{hash_name}[#{index}]")

            params["#{hash_url_key}.key"]   = key
            params["#{hash_url_key}.name"]  = key
            params["#{hash_url_key}.value"] = value
          end
          params.delete hash_name
        end
      end

      # TODO: isn't this done with the RemoveEmptyStrings middleware?
      def remove_falseish(hash)
        hash.reject { |_, v| v == '' || v =~ /false/i || !v }
      end
    end
  end
end
