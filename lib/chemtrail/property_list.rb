class Chemtrail::PropertyList < Hash
  def to_hash
    reduce(self) do |property_list, (key, value)|
      property_list[key] = Chemtrail::ReferencePresenter.new(value).to_parameter
      property_list
    end
  end
end
