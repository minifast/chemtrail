require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_property do |property_name|
    define_method :resource_for do |actual|
      actual.resources.detect { |resource| resource.id == @resource_id }
    end

    define_method :property_for do |resource|
      resource.properties[property_name]
    end

    define_method :matches_value? do |property|
      if @value
        property == @value
      else
        true
      end
    end

    match do |actual|
      resource = resource_for(actual)
      property = property_for(resource)
      !resource.nil? && !property.nil? && matches_value?(property)
    end

    chain :on do |resource_id|
      @resource_id = resource_id
    end

    chain :with_value do |value|
      @value = value
    end

    chain :including do |value|
      @included_value = value
    end

    failure_message_for_should do |actual|
      if resource = resource_for(actual)
        if property = property_for(resource)
          %(expected resource #{@resource_id.inspect} property #{property_name.inspect} to have value #{@value.inspect}, but got #{property.inspect})
        else
          %(expected resource #{@resource_id.inspect} to have property #{property_name.inspect})
        end
      else
        %(expected to find resource #{@resource_id.inspect}, but got nothing)
      end
    end
  end
end
