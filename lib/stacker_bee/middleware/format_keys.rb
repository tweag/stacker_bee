module StackerBee
  module Middleware
    class FormatKeys < Base
      include Utilities

      def params(params)
        transform_hash_keys(params) do |key|
          camel_case(key, true)
        end
      end
    end
  end
end
