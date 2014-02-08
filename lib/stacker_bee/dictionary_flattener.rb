module StackerBee
  class DictionaryFlattener
    LB = "SBLEFTBRACKET"
    RB = "SBRIGHTBRACKET"

    attr_accessor :params

    def self.tokenize(key)
      key.gsub("[", LB).gsub("]", RB)
    end

    def self.detokenize(key)
      key.gsub(LB, "[").gsub(RB, "]")
    end

    def initialize(params)
      self.params = params.dup
      flatten_params
    end

    def flatten_params
      hashes = params.select { |_, val| val.respond_to?(:keys) }
      flatten_map_values params, hashes
    end

    def flatten_map_values(params, hashes)
      hashes.each do |hash_name, hash|
        remove_empties(hash).each_with_index do |(key, value), index|
          hash_url_key = self.class.tokenize("#{hash_name}[#{index}]")
          params["#{hash_url_key}.key"] = params["#{hash_url_key}.name"] = key
          params["#{hash_url_key}.value"] = value
        end
        params.delete hash_name
      end
    end

    def remove_empties(hash)
      hash.reject { |_, v| v.nil? || v == "" }
    end
  end
end
