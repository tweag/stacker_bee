module StackerBee
  module Middleware
    class FormatValues < Base
      include Utilities

      def params(params)
        transform_hash_values(params) do |value|
          value.respond_to?(:join) ? value.join(',') : value.to_s
        end
      end
    end
  end
end
