module StackerBee
  module Middleware
    class Environment < OpenStruct
      def initialize(request_attributes = {})
        super()

        defaults = { params: {} }
        self.request = OpenStruct.new(defaults.merge(request_attributes))
      end
    end
  end
end
