module StackerBee
  class Builder
    attr_accessor :middlewares

    def middlewares
      @middlewares ||= []
    end

    def use(*middleware_definition)
      middlewares << middleware_definition
    end

    def before(*middleware_definition)
      middlewares.unshift middleware_definition
    end

    def build
      middlewares.map { |klass, *args| klass.new(*args) }
    end
  end
end
