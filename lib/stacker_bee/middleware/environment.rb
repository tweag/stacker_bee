module StackerBee
  module Middleware
    class Environment < OpenStruct
      def initialize(request_attributes = {})
        super()

        defaults = { params: {} }
        self.request = OpenStruct.new(defaults.merge(request_attributes))

        self.response = OpenStruct.new
      end
    end
  end
end
