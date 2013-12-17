require "rspec/expectations"

module Chemtrail::RSpec
  extend RSpec::Matchers::DSL

  matcher :have_parameter do |parameter_id|
    define_method :parameter_for do |parameter_list|
      parameter_list.detect { |param| param.id == parameter_id }
    end

    define_method :matches_type? do |parameter|
      @type.nil? || parameter.type == @type
    end

    match do |parameter_list|
      parameter = parameter_for(parameter_list)
      !parameter.nil? && matches_type?(parameter)
    end

    chain :with_type do |type|
      @type = type
    end

    failure_message_for_should do |parameter_list|
      if parameter = parameter_for(parameter_list)
        %(expected parameter #{parameter_id.inspect} to have type #{@type.inspect}, but got #{parameter.type.inspect})
      else
        %(expected to find parameter #{parameter_id.inspect}, but got nothing)
      end
    end
  end
end
