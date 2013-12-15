require "chemtrail/section"

class Chemtrail::Template
  attr_reader :description

  def initialize(description)
    @description = description
  end

  def parameters
    @parameters ||= Chemtrail::Section.new
  end

  def mappings
    @mappings ||= Chemtrail::Section.new
  end

  def resources
    @resources ||= Chemtrail::Section.new
  end

  def outputs
    @outputs ||= Chemtrail::Section.new
  end

  def to_hash
    {
      "AWSTemplateFormatVersion" => "2010-09-09",
      "Description" => description,
      "Parameters" => parameters.to_hash,
      "Mappings" => mappings.to_hash,
      "Resources" => resources.to_hash,
      "Outputs" => outputs.to_hash
    }
  end
end
