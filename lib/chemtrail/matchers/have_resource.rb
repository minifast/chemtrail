require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_resource do |resource_id|
    define_method :resource_for do |resource_list|
      resource_list.detect { |resource| resource.id == resource_id }
    end

    define_method :matches_type? do |resource|
      @type.nil? || resource.type == @type
    end

    match do |resource_list|
      resource = resource_for(resource_list)
      !resource.nil? && matches_type?(resource)
    end

    chain :with_type do |type|
      @type = type
    end

    failure_message_for_should do |resource_list|
      if resource = resource_for(resource_list)
        %(expected resource #{resource_id.inspect} to have type #{@type.inspect}, but got #{resource.type.inspect})
      else
        %(expected to find resource #{resource_id.inspect}, but got nothing)
      end
    end
  end
end
