require "rspec/expectations"
require_relative "have_parameter"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  alias :have_resource :have_parameter
end
