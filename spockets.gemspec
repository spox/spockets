Gem::Specification.new do |s|
  s.name = 'spockets'
  s.author = 'spox'
  s.email = 'spox@modspox.com'
  s.version = '0.1.1'
  s.summary = 'Socket Helper'
  s.rdoc_options = %w(--title Spockets --main README.rdoc --line-numbers)
  s.files = Dir.glob(File.join(File.dirname(__FILE__), '**', '*'))
  s.require_paths = %w(lib)
  s.add_dependency 'actionpool'
  s.homepage      = %q(http://github.com/spox/spockets)
  s.description = 'Socket helper library'
end
