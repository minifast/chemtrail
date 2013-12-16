require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_tag do |key_name|
    define_method :resource_for do |actual|
      actual.resources.detect { |resource| resource.id == @resource_id }
    end

    define_method :tag_for do |resource|
      tags = resource.properties["Tags"] || []
      tags.detect { |tag| tag["Key"] == key_name }
    end

    define_method :matches_value? do |tag|
      if @value
        tag["Value"] == @value
      elsif @reference
        tag["Value"].id == @reference
      else
        true
      end
    end

    match do |actual|
      resource = resource_for(actual)
      tag = tag_for(resource)
      !resource.nil? && !tag.nil? && matches_value?(tag)
    end

    chain :on do |resource_id|
      @resource_id = resource_id
    end

    chain :with_value do |value|
      @value = value
    end

    chain :with_reference do |reference|
      @reference = reference
    end

    failure_message_for_should do |actual|
      if resource = resource_for(actual)
        if tag = tag_for(resource)
          if @value
            %(expected resource #{@resource_id.inspect} tag #{key_name.inspect} to have value #{@value.inspect}, but got #{tag["Value"].inspect})
          else
            %(expected resource #{@resource_id.inspect} tag #{key_name.inspect} to refer to #{@reference.inspect}, but got #{tag["Value"].id.inspect})
          end
        else
          %(expected resource #{@resource_id.inspect} to have tag #{key_name.inspect})
        end
      else
        %(expected to find resource #{@resource_id.inspect}, but got nothing)
      end
    end
  end
end
