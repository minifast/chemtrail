require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_mapping do |expected|
    match { |actual| actual.mappings.any? { |m| m.id == expected } }
  end
end
