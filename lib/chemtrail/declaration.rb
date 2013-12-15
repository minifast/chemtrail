class Chemtrail::Declaration
  attr_reader :id, :type

  def initialize(id, type, specifications = {})
    @id = id
    @type = type
    @specifications = specifications
  end

  def specifications
    @specifications ||= {}
  end

  def to_reference
    {
      "Ref" => id
    }
  end

  def to_hash
    {
      id => {
        "Type" => type
      }.merge(specifications)
    }
  end
end
