require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

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
