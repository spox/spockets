$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib"))

require 'spockets'
require 'test/unit'

Dir.glob(File.join(File.dirname(__FILE__), 'cases', '**', '*.rb')).each do |file|
  require File.expand_path(file)
end

