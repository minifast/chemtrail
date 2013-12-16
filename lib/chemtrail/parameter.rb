class Chemtrail::Parameter
  attr_reader :id, :type

  def initialize(id, type, fields = {})
    @id = id
    @type = type
    @fields = fields
  end

  def fields
    @fields ||= {}
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
      }.merge(fields)
    }
  end
end
