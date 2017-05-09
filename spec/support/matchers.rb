require 'rspec/expectations'

RSpec::Matchers.define :include_output do |expected|
  matcher = RSpec::Matchers::BuiltIn::Include.new(expected)
  match do |actual|
    matcher.matches?(Pastel.new.strip(actual))
  end
end
