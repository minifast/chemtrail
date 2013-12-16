require "chemtrail/section_presenter"
require "chemtrail/class_name_inflector"

class Chemtrail::Template
  class << self
    def subclass_map
      @subclass_map ||= {}
    end

    def inherited(subclass)
      subclass_map[Chemtrail::ClassNameInflector.new(subclass).underscore] = subclass
    end
  end

  attr_reader :description

  def initialize(description = nil)
    @description = description
  end

  def parameters
    []
  end

  def mappings
    []
  end

  def resources
    []
  end

  def outputs
    []
  end

  def to_hash
    version_hash = {"AWSTemplateFormatVersion" => "2010-09-09"}
    version_hash.merge(description_hash)
                .merge(parameters_hash)
                .merge(mappings_hash)
                .merge(resources_hash)
                .merge(outputs_hash)
  end

  protected

  def description_hash
    hash = {}
    hash["Description"] = description unless description.nil?
    hash
  end

  def parameters_hash
    Chemtrail::SectionPresenter.new("Parameters", parameters).to_hash
  end

  def mappings_hash
    Chemtrail::SectionPresenter.new("Mappings", mappings).to_hash
  end

  def resources_hash
    Chemtrail::SectionPresenter.new("Resources", resources).to_hash
  end

  def outputs_hash
    Chemtrail::SectionPresenter.new("Outputs", outputs).to_hash
  end
end
