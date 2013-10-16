module StackerBee
  module Utilties
    def snake_case(string)
      string.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase
    end

    def camel_case(string)
      string = string.to_s
      return string if string !~ /_/ && string =~ /[A-Z]+.*/
      string.split('_').map{|e| e.capitalize }.join
    end

    def camel_case_lower(string)
      string.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
    end
  end
end
