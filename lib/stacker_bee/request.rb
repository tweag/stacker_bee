require "stacker_bee/utilities"

module StackerBee
  class Request
    attr_accessor :params

    def initialize(_, _, params = {})
      self.params = params
    end

    def query_params
      params.to_a.sort # For consistency sake; helpful for testing and debugging
    end
  end
end
