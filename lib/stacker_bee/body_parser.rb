require "multi_json"
require "stacker_bee/rash"

module StackerBee
  module BodyParser
    attr_reader :body

    def body=(raw_response)
      @body = parse(raw_response.body)
    end

    def parse(json)
      parsed = MultiJson.load(json)
      fail "Cannot determine response key in #{parsed.keys}" if parsed.size > 1
      case value = parsed.values.first
      when Hash  then Rash.new(value)
      when Array then value.map { |item| Rash.new(item) }
      else
        value
      end
    end
  end
end
