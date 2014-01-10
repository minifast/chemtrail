require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_field do |field_name|
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

    match do |parameter|
      field = field_for(parameter)
      !field.nil? && matches_value?(field)
    end

    chain :with_value do |value|
      @value = value
    end

    chain :including do |value|
      @included_value = value
    end

    failure_message_for_should do |parameter|
      if field = field_for(parameter)
        expected_field = @value || @included_value
        %(expected parameter #{parameter.id} field #{field_name.inspect} to have value #{expected_field.inspect}, but got #{field.inspect})
      else
        %(expected parameter #{parameter.id} to have field #{field_name.inspect})
      end
    end
  end
end
