class Chemtrail::Intrinsic
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def to_reference
    {
      "Ref" => id
    }
  end

  def as_tag(key)
    {"Key" => key, "Value" => self}
  end
end
