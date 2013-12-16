require "chemtrail/reference_presenter"

class Chemtrail::Mapping
  attr_reader :id

  def initialize(id, entries = nil)
    @id = id
    @entries = entries
  end

  def entries
    @entries ||= {}
  end

  def find(top_level, second_level)
    Chemtrail::Function.new("Fn::FindInMap", id, top_level, second_level).to_hash
  end

  def to_hash
    {
      id => entries
    }
  end
end
