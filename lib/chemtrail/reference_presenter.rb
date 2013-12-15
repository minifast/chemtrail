class Chemtrail::ReferencePresenter
  attr_reader :argument

  def initialize(argument)
    @argument = argument
  end

  def reference?
    argument.respond_to?(:to_reference)
  end

  def to_parameter
    if reference?
      argument.to_reference
    else
      argument
    end
  end
end
