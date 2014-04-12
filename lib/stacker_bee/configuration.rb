require "ostruct"

module StackerBee
  class Configuration < OpenStruct
    def ssl_verify?
      !ssl_verify.nil? ? ssl_verify : true
    end
  end
end
