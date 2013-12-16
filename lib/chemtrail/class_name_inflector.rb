class Chemtrail::ClassNameInflector
  attr_reader :class_name

  def initialize(class_name)
    @class_name = class_name.to_s.dup
  end

  def underscore
    class_name.gsub(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
              .gsub(/([a-z\d])([A-Z])/,'\1_\2')
              .gsub(/::/,':')
              .downcase
  end
end
