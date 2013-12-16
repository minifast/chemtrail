class Chemtrail::Resource
  attr_reader :id, :type

  def initialize(id, type, properties = nil)
    @id = id
    @type = type
    @properties = Chemtrail::PropertyList.new.merge(properties) if properties
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
