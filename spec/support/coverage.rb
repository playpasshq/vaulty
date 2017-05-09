if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.add_filter '/spec/'

  if ENV['TRAVIS']
    require 'coveralls'
    require 'codecov'
    SimpleCov.formatter = SimpleCov::Formatter::Codecov
    Coveralls.wear!
  end

  SimpleCov.command_name "rspec_#{Process.pid}"
  SimpleCov.start
end
