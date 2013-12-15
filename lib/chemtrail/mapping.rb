require "chemtrail/reference_presenter"

class Chemtrail::Mapping
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def entries
    @entries ||= {}
  end

  def find(top_level, second_level)
    {
      "Fn::FindInMap" => [
        id,
        Chemtrail::ReferencePresenter.new(top_level).to_parameter,
        Chemtrail::ReferencePresenter.new(second_level).to_parameter
      ]
    }
  end

  def to_hash
    {
      id => entries
    }
  end
end
