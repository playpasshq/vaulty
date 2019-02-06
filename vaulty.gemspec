# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'vaulty', 'version.rb'])
Gem::Specification.new do |s|
  s.name = 'vaulty'
  s.version = Vaulty::VERSION
  s.author = ['Jan Stevens']
  s.email = ['jan@playpass.be']
  s.platform = Gem::Platform::RUBY

  s.summary = 'A description of your project'
  s.description = 'Vault CLI that is based on the Vault Ruby gem'
  s.homepage = 'https://fritz.ninja'
  s.license = 'MIT'

  s.required_ruby_version = '~> 2.5'

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.bindir = 'bin'
  s.require_paths << 'lib'
  s.executables << 'vaulty'

  s.add_dependency 'hashdiff', '~> 0.3.0'
  s.add_dependency 'hirb', '~> 0.7.3'
  s.add_dependency 'tty-prompt', '~> 0.18.0'
  s.add_dependency 'tty-spinner', '~> 0.9.0'
  s.add_dependency 'tty-table', '~> 0.10.0'
  s.add_dependency 'pastel', '~> 0.7.2'
  s.add_dependency 'vault', '~> 0.12.0'

  s.add_development_dependency 'rake'

  s.add_runtime_dependency 'gli', '2.18.0'
end
