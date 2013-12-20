module StackerBee
  module Utilities
    REGEX = /\s|-|_/

    def uncase(string)
      string.to_s.downcase.gsub(REGEX, '')
    end

    def snake_case(string)
      string.to_s.gsub(/(.)([A-Z])/, '\1_\2').gsub(/(\W|_)+/, '_').downcase
    end

    def camel_case(string, lower = false)
      string.to_s.split(REGEX).each_with_object('') do |word, memo|
        memo << (memo.empty? && lower ? word[0].downcase : word[0].upcase)
        memo << word[1..-1]
      end
    end
  end
end
