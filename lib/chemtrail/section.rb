class Chemtrail::Section < Array
  def to_hash
    map(&:to_hash).reduce(Hash.new, :merge)
  end
end
