class Chemtrail::Output
  attr_reader :id, :value, :description

  def initialize(id, value, description = nil)
    @id = id
    @value = value
    @description = description
  end

  def value_parameter
    Chemtrail::ReferencePresenter.new(value).to_parameter
  end

  def description_hash
    if description.nil?
      {}
    else
      {"Description" => description}
    end
  end

  def to_hash
    {
      id => {
        "Value" => value_parameter
      }.merge(description_hash)
    }
  end
end
