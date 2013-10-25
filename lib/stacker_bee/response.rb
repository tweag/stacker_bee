require "forwardable"
require "stacker_bee/body_parser"
require "stacker_bee/request_error"

module StackerBee
  class Response
    include BodyParser
    extend Forwardable
    def_delegators :body, :[], :[]=, :empty?, :keys, :inspect, :to_s, :first

    def initialize(raw_response)
      fail RequestError.for(raw_response) unless raw_response.success?
      super(raw_response)
    end

    protected

    def parse(json)
      parsed = super(json)
      return parsed unless parsed.respond_to? :keys

      if parsed.size == 2 && parsed.key?("count")
        parsed.delete("count")
        parsed.values.first
      elsif parsed.size == 1 && parsed.values.first.is_a?(Hash)
        parsed.values.first
      else
        parsed
      end
    end
  end
end
