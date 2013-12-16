require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

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
end
