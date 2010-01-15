spec = Gem::Specification.new do |s|
    s.name              = 'spockets'
    s.author            = %q(spox)
    s.email             = %q(spox@modspox.com)
    s.version           = '0.1.0'
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