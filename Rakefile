require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rspec/core/rake_task'

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Your application title'
end

spec = eval(File.read('vaulty.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

RSpec::Core::RakeTask.new(:spec)

task default: %i(spec)
