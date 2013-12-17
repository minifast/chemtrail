require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_tag do |key_name|
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

    match do |resource|
      tag = tag_for(resource)
      !resource.nil? && !tag.nil? && matches_value?(tag)
    end

    chain :with_value do |value|
      @value = value
    end

    chain :with_reference do |reference|
      @reference = reference
    end

    failure_message_for_should do |resource|
      if tag = tag_for(resource)
        if @value
          %(expected resource #{resource.id} tag #{key_name.inspect} to have value #{@value.inspect}, but got #{tag["Value"].inspect})
        else
          %(expected resource #{resource.id} tag #{key_name.inspect} to refer to #{@reference.inspect}, but got #{tag["Value"].id.inspect})
        end
      else
        %(expected resource #{resource.id} to have tag #{key_name.inspect})
      end
    end
  end
end
