require_stacker_bee = if defined?(require_relative)
  lambda do |path|
    require_relative path
  end
else # for 1.8.7
  lambda do |path|
    require "stacker_bee/#{path}"
  end
end

%w(version configuration client).each do |file_name|
  require_stacker_bee["stacker_bee/#{file_name}"]
end

module StackerBee
end
