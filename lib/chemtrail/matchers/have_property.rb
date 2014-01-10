require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_property do |property_name|
    define_method :property_for do |resource|
      resource.properties[property_name]
    end

    define_method :matches_value? do |property|
      if @finder
        property == Chemtrail::Function.new("Fn::FindInMap", *@finder).to_hash
      elsif @value
        property == @value
      elsif @reference
        property.id == @reference
      else
        true
      end
    end

    define_method :includes_value? do |property|
      if @value
        property.includes?(@value)
      elsif @reference
        property.any? { |p| p.id == @reference }
      else
        true
      end
    end

    define_method :matches_strategy? do |property|
      if @including
        includes_value?(property)
      else
        matches_value?(property)
      end
    end

    match do |resource|
      property = property_for(resource)
      !resource.nil? && !property.nil? && matches_strategy?(property)
    end

    chain :with_value do |value|
      @value = value
    end

    chain :with_reference do |reference|
      @reference = reference
    end

    chain :including_value do |value|
      @including = true
      @value = value
    end

    chain :including_reference do |reference|
      @including = true
      @reference = reference
    end

    chain :with_finder do |mapping_name, key, subkey|
      @finder = [mapping_name, key, subkey]
    end

    failure_message_for_should do |resource|
      if property = property_for(resource)
        if @finder
          %(expected resource #{resource.id} property #{property_name.inspect} to have searched #{@finder[0]} for #{@finder[1]} #{@finder[2]})
        elsif @value
          %(expected resource #{resource.id} property #{property_name.inspect} to have value #{@value.inspect}, but got #{property.inspect})
        else
          %(expected resource #{resource.id} property #{property_name.inspect} to refer to #{@reference.inspect}, but got #{property.id.inspect})
        end
      else
        %(expected resource #{resource.id} to have property #{property_name.inspect})
      end
    end
  end
end
