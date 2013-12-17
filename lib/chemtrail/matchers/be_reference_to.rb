require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :be_reference_to do |expected|
    match do |actual|
      actual.id == expected
    end
  end
end
