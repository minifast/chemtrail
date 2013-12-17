require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_mapping do |mapping_id|
    match do |mapping_list|
      mapping_list.any? { |m| m.id == mapping_id }
    end
  end
end
