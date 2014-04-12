require "ostruct"

module StackerBee
  class Configuration < OpenStruct
    def ssl_verify?
      # rubocop:disable NonNilCheck
      # it should default to true if it's not explicitly set
      !ssl_verify.nil? ? ssl_verify : true
    end
  end
end
