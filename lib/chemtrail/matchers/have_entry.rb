require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_entry do |entry_name|
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

    match do |mapping|
      entry = entry_for(mapping)
      !mapping.nil? && !entry.nil? && matches_value?(entry)
    end

    chain :including do |value|
      @included_value = value
    end

    failure_message_for_should do |mapping|
      if entry = entry_for(mapping)
        %(expected mapping #{mapping.id} field #{entry_name.inspect} to have value #{@included_value.inspect}, but got #{entry.inspect})
      else
        %(expected mapping #{mapping.id} to have type #{entry_name.inspect})
      end
    end
  end
end
