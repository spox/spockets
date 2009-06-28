spec = Gem::Specification.new do |s|
    s.name              = 'spockets'
    s.author            = %q(spox)
    s.email             = %q(spox@modspox.com)
    s.version           = '0.0.6'
    s.summary           = %q(Socket Helper)
    s.platform          = Gem::Platform::RUBY
    s.has_rdoc          = true
    s.rdoc_options      = %w(--title Spockets --main README.rdoc --line-numbers)
    s.extra_rdoc_files  = %w(README)
    s.files             = %w(README.rdoc CHANGELOG lib/spockets.rb lib/spockets/Exceptions.rb lib/spockets/Spockets.rb lib/spockets/Watcher.rb)
    s.require_paths     = %w(lib)
    s.add_dependency 'ActionPool'
    s.homepage          = %q(http://dev.modspox.com/trac/spockets)
    s.description = 'Socket helper library'
end