require "chemtrail"
require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_parameter do |parameter_id|
    define_method :parameter_for do |actual|
      actual.parameters.detect { |param| param.id == parameter_id }
    end

    define_method :matches_type? do |actual|
      @type.nil? || parameter_for(actual).type == @type
    end

    match do |actual|
      !parameter_for(actual).nil? && matches_type?(actual)
    end

    chain :with_type do |type|
      @type = type
    end

    failure_message_for_should do |actual|
      if parameter = parameter_for(actual)
        %(expected parameter #{parameter_id.inspect} to have type #{@type.inspect}, but got #{parameter.type.inspect})
      else
        %(expected to find parameter #{parameter_id.inspect}, but got nothing)
      end
    end
  end

  matcher :have_field do |field_name|
    define_method :parameter_for do |actual|
      actual.parameters.detect { |p| p.id == @parameter_id }
    end

    define_method :field_for do |parameter|
      parameter.fields[field_name]
    end

    define_method :matches_value? do |field|
      if @value
        field == @value
      elsif @included_value
        field.include?(@included_value)
      else
        true
      end
    end

    match do |actual|
      parameter = parameter_for(actual)
      field = field_for(parameter)
      !parameter.nil? && !field.nil? && matches_value?(field)
    end

    chain :on do |parameter_id|
      @parameter_id = parameter_id
    end

    chain :with_value do |value|
      @value = value
    end

    chain :including do |value|
      @included_value = value
    end

    failure_message_for_should do |actual|
      if parameter = parameter_for(actual)
        if field = field_for(parameter)
          expected_field = @value || @included_value
          %(expected parameter #{@parameter_id.inspect} field #{field_name.inspect} to have value #{expected_field.inspect}, but got #{field.inspect})
        else
          %(expected parameter #{@parameter_id.inspect} to have type #{field_name.inspect})
        end
      else
        %(expected to find parameter #{@parameter_id.inspect}, but got nothing)
      end
    end
  end

  matcher :have_mapping do |expected|
    match { |actual| actual.mappings.any? { |m| m.id == expected } }
  end

  matcher :have_mapping_key do |entry_name|
    define_method :mapping_for do |actual|
      actual.mappings.detect { |m| m.id == @mapping_id }
    end

    define_method :entry_for do |mapping|
      mapping.entries[entry_name]
    end

    define_method :matches_value? do |entry|
      if @included_value
        entry.values_at(*@included_value.keys) == @included_value.values
      else
        true
      end
    end

    match do |actual|
      mapping = mapping_for(actual)
      entry = entry_for(mapping)
      !mapping.nil? && !entry.nil? && matches_value?(entry)
    end

    chain :on do |mapping_id|
      @mapping_id = mapping_id
    end

    chain :including do |value|
      @included_value = value
    end

    failure_message_for_should do |actual|
      if mapping = mapping_for(actual)
        if entry = entry_for(mapping)
          %(expected mapping #{@mapping_id.inspect} field #{entry_name.inspect} to have value #{@included_value.inspect}, but got #{entry.inspect})
        else
          %(expected mapping #{@mapping_id.inspect} to have type #{entry_name.inspect})
        end
      else
        %(expected to find mapping #{@mapping_id.inspect}, but got nothing)
      end
    end
  end
end
