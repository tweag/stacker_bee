module StackerBee
  class DictionaryFlattener
    LB = "SBLEFTBRACKET"
    RB = "SBRIGHTBRACKET"

    attr_accessor :params

    def self.tokenize(key)
      key.gsub(/\[/, LB).gsub(/\]/, RB)
    end

    def self.detokenize(key)
      key.gsub(/#{LB}/, "[").gsub(/#{RB}/, "]")
    end

    def initialize(params)
      @params = params.dup
      flatten_params
    end

    def flatten_params
      hashes = params.select { |key, val|  val.respond_to? :keys }
      flatten_map_values(params, hashes)
    end

    def flatten_map_values(params, hashes)
      hashes.each do |outer|
        remove_empties(outer[1]).each_with_index do |array, index|
          key = self.class.tokenize("#{outer[0]}[#{index}]")
          params["#{key}.key"] = params["#{key}.name"] = array[0]
          params["#{key}.value"] = array[1]
        end
        params.delete outer[0]
      end
    end

    def remove_empties(hash)
      hash.reject { |k, v| v.nil? || v == "" }
    end
  end
end
