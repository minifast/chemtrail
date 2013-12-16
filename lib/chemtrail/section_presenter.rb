class Chemtrail::SectionPresenter
  attr_reader :name, :entries

  def initialize(name, entries)
    @name = name
    @entries = entries
  end

  def to_hash
    if entries.empty?
      {}
    else
      {name => entries.map(&:to_hash).reduce(Hash.new, :merge)}
    end
  end
end
