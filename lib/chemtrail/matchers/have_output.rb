require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_output do |output_id|
    define_method :output_for do |output_list|
      output_list.detect { |output| output.id == output_id }
    end

    define_method :matches_value? do |output|
      if @value
        output.value == @value
      elsif @reference
        output.value.id == @reference
      else
        true
      end
    end

    match do |output_list|
      output = output_for(output_list)
      !output.nil? && matches_value?(output)
    end

    chain :with_value do |value|
      @value = value
    end

    chain :with_reference do |reference|
      @reference = reference
    end

    failure_message_for_should do |output_list|
      if output = output_for(output_list)
        if @value
          %(expected output #{output.id} property #{property_name.inspect} to have value #{@value.inspect}, but got #{output.value.inspect})
        else
          %(expected output #{output.id} property #{property_name.inspect} to refer to #{@reference.inspect}, but got #{output.id.inspect})
        end
      else
        %(expected to find output #{output_id.inspect}, but got nothing)
      end
    end
  end
end
