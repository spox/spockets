# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'

spec = Gem::Specification.new do |s|
    s.name              = 'spockets'
    s.author            = %q(spox)
    s.email             = %q(spox@modspox.com)
    s.version           = '0.1.1'
    s.summary           = %q(Socket Helper)
    s.platform          = Gem::Platform::RUBY
    s.has_rdoc          = true
    s.rdoc_options      = %w(--title Spockets --main README.rdoc --line-numbers)
    s.extra_rdoc_files  = %w(README.rdoc)
    s.files             = %w(README.rdoc CHANGELOG lib/spockets.rb lib/spockets/Exceptions.rb lib/spockets/Spockets.rb lib/spockets/Watcher.rb)
    s.require_paths     = %w(lib)
    s.add_dependency 'actionpool', '~> 0.2.3'
    s.homepage          = %q(http://github.com/spox/spockets)
    s.description = 'Socket helper library'
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "spockets Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*.rb']
  t.libs << Dir["lib"]
end
