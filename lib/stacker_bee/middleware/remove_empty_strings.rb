module StackerBee
  module Middleware
    class RemoveEmptyStrings < Base
      def call(env)
        deeply_remove_empty_strings env.request.params
        app.call(env)
      end

      def deeply_remove_empty_strings(hash)
        hash.delete_if { |_, val| val == '' }

        hash.values
          .select{ |val| val.respond_to?(:to_hash) }.each do |val|
            deeply_remove_empty_strings val
          end
      end
    end
  end
end
