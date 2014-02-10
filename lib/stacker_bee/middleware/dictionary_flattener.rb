module StackerBee
  module Middleware
    class DictionaryFlattener < Base
      def params(params)
        StackerBee::DictionaryFlattener.new(params).params
      end
    end
  end
end
