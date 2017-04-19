if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.add_filter '/spec/'

  if ENV['TRAVIS']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end

  SimpleCov.command_name "rspec_#{Process.pid}"
  SimpleCov.start
end
