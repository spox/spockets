$LOAD_PATH.unshift(File.expand_path("#{__FILE__}/../../lib"))

require 'spockets'
require 'test/unit'

Dir.new("#{File.dirname(__FILE__)}/cases").each{|f|
    require "#{File.dirname(__FILE__)}/cases/#{f}" if f[-2..f.size] == 'rb'
}