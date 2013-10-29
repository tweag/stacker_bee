require "stacker_bee/body_parser"
require "stacker_bee/request_error"
require 'delegate'

module StackerBee
  class Response < SimpleDelegator
    include BodyParser

    def initialize(raw_response)
      fail RequestError.for(raw_response) unless raw_response.success?
      self.body = raw_response
      super body
    end

    protected

    def parse(json)
      parsed = super(json)
      return parsed unless parsed.respond_to? :keys
      if parsed.size == 2 && parsed.key?("count")
        parsed.reject { |key, val| key == "count" }.values.first
      elsif parsed.size == 1 && parsed.values.first.respond_to?(:keys)
        parsed.values.first
      else
        parsed
      end
    end
  end
end
