class Chemtrail::Function
  attr_reader :name, :arguments

  def initialize(name, *arguments)
    @name = name
    @arguments = arguments
  end

  def argument_list
    @argument_list ||= arguments.map do |argument|
      Chemtrail::ReferencePresenter.new(argument).to_parameter
    end
  end

  def to_hash
    {
      name => argument_list.count > 1 ? argument_list : argument_list.first || ""
    }
  end
end
