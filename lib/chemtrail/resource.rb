class Chemtrail::Resource
  attr_reader :id, :type

  def initialize(id, type)
    @id = id
    @type = type
  end

  def to_reference
    { "Ref" => id }
  end

  def properties
    @properties ||= Chemtrail::PropertyList.new
  end

  def to_hash
    {
      id => {
        "Type" => type,
        "Properties" => properties.to_hash
      }
    }
  end
end
