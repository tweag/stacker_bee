module StackerBee
  module Middleware
    class RemoveNils < Base
      def transform_params(params)
        params.reject { |key, val| val.nil? }
      end
    end
  end
end
