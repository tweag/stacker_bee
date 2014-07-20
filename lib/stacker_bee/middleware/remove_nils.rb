module StackerBee
  module Middleware
    class RemoveNils < Base
      def transform_params(params)
        params.reject { |_, val| val.nil? }
      end
    end
  end
end
