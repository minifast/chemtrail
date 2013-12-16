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
end
