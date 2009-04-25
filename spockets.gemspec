spec = Gem::Specification.new do |s|
    s.name              = 'spockets'
    s.author            = %q(spox)
    s.email             = %q(spox@modspox.com)
    s.version           = '0.0.5'
    s.summary           = %q(Socket Helper)
    s.platform          = Gem::Platform::RUBY
    s.has_rdoc          = true
    s.rdoc_options      = %w(--title Spockets --main README --line-numbers)
    s.extra_rdoc_files  = %w(README)
    s.files             = Dir['**/*']
    s.require_paths     = %w(lib)
    s.add_dependency 'ActionPool'
    s.homepage          = %q(http://dev.modspox.com/trac/spockets)
    description         = []
    File.open("README") do |file|
        file.each do |line|
            line.chomp!
            break if line.empty?
            description << "#{line.gsub(/\[\d\]/, '')}"
        end
    end
    s.description = description[1..-1].join(" ")
end