if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.add_filter '/spec/'
  SimpleCov.start
  SimpleCov.command_name "rspec_#{Process.pid}"
end
