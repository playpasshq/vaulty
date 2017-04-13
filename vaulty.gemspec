# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','vaulty','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'vaulty'
  s.version = Vaulty::VERSION
  s.author = ['Jan Stevens']
  s.email = ['jan@playpass.be']
  s.platform = Gem::Platform::RUBY

  s.summary = %q{A description of your project}
  s.description = %q{Vault CLI that is based on the Vault Ruby gem}
  s.homepage = 'https://fritz.ninja'
  s.license = "MIT"

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir = 'bin'
  s.require_paths << 'lib'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','vaulty.rdoc']
  s.rdoc_options << '--title' << 'vaulty' << '--main' << 'README.rdoc' << '-ri'

  s.executables << 'vaulty'

  s.add_dependency "vault", '~> 0.9'
  s.add_dependency 'procto', '~> 0.0.3'
  s.add_dependency 'hirb', '~> 0.7.3'
  s.add_dependency 'hashdiff', '~> 0.3.0'
  s.add_dependency 'virtus', '~> 1.0.5'
  s.add_dependency 'highline', '~> 1.7.8'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'rspec'

  s.add_runtime_dependency 'gli', '2.16.0'
end
