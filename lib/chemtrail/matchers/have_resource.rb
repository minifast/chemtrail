require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_resource do |resource_id|
    define_method :resource_for do |actual|
      actual.resources.detect { |resource| resource.id == resource_id }
    end

    define_method :matches_type? do |actual|
      @type.nil? || resource_for(actual).type == @type
    end

    match do |actual|
      !resource_for(actual).nil? && matches_type?(actual)
    end

    chain :with_type do |type|
      @type = type
    end

    failure_message_for_should do |actual|
      if resource = resource_for(actual)
        %(expected resource #{resource_id.inspect} to have type #{@type.inspect}, but got #{resource.type.inspect})
      else
        %(expected to find resource #{resource_id.inspect}, but got nothing)
      end
    end
  end
end
