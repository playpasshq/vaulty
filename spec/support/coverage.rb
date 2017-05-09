if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  if ENV['TRAVIS']
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end

  SimpleCov.start
end
