class FakeLogger
  attr_accessor :logs
  def initialize
    @logs = []
  end

  def debug(obj)
    logs << obj
  end

  def info(obj)
    logs << obj
  end

  def warn(obj)
    logs << obj
  end

  def error(obj)
    logs << obj
  end

  def fatal(obj)
    logs << obj
  end
end
