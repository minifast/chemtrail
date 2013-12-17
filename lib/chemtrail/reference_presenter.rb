class Chemtrail::ReferencePresenter
  attr_reader :argument

  def initialize(argument)
    @argument = argument
  end

  def reference?
    argument.respond_to?(:to_reference)
  end

  def iterable?
    argument.respond_to?(:each)
  end

  def hashlike?
    argument.respond_to?(:to_hash)
  end

  def to_parameter
    if reference?
      argument.to_reference
    else
      if iterable?
        if hashlike?
          argument.reduce(argument) { |h, (k, v)| h[k] = self.class.new(v).to_parameter; h }
        else
          argument.map { |item| self.class.new(item).to_parameter }
        end
      else
        argument
      end
    end
  end
end
