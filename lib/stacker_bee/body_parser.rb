require "multi_json"

module StackerBee
  module BodyParser
    attr_reader :body

    def initialize(raw_response)
      @body = parse(raw_response.body)
    end

    def parse(json)
      parsed = MultiJson.load(json)
      response_key = parsed.keys.first if parsed.keys.size == 1
      return parsed[response_key] if response_key
      fail "Unable to determine response key in #{parsed.keys}"
    end
  end
end
