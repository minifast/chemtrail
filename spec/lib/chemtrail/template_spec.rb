require "spec_helper"

describe Chemtrail::Template do
  let(:fake_mapping) { double(:mapping, to_hash: {"mapping" => "json"}) }
  let(:fake_output) { double(:output, to_hash: {"output" => "json"}) }
  let(:fake_parameter) { double(:parameter, to_hash: {"parameter" => "json"}) }
  let(:fake_resource) { double(:resource, to_hash: {"resource" => "json"}) }

  subject(:template) { Chemtrail::Template.new }

  describe "#to_hash" do
    its(:to_hash) { should include("AWSTemplateFormatVersion" => "2010-09-09") }
    its(:to_hash) { should_not have_key "Parameters" }
    its(:to_hash) { should_not have_key "Mappings" }
    its(:to_hash) { should_not have_key "Resources" }
    its(:to_hash) { should_not have_key "Outputs" }

    context "when the description is not set" do
      its(:to_hash) { should_not have_key "Description" }
    end

    context "when the description is set" do
      subject(:template) { Chemtrail::Template.new("super great") }

      its(:to_hash) { should include("Description" => "super great") }
    end

    context "when the template has parameters" do
      before { template.stub(parameters: [fake_parameter]) }

      its(:to_hash) { should include("Parameters" => {"parameter" => "json"}) }
    end

    context "when the template has mappings" do
      before { template.stub(mappings: [fake_mapping]) }

      its(:to_hash) { should include("Mappings" => {"mapping" => "json"}) }
    end

    context "when the template has resources" do
      before { template.stub(resources: [fake_resource]) }

      its(:to_hash) { should include("Resources" => {"resource" => "json"}) }
    end

    context "when the template has outputs" do
      before { template.stub(outputs: [fake_output]) }

      its(:to_hash) { should include("Outputs" => {"output" => "json"}) }
    end
  end

  describe ".inherited" do
    before { Chemtrail::Template.stub(subclass_map: {}) }

    it "adds subclasses to the template map" do
      expect {
        Chemtrail::Template.send(:inherited, Object)
      }.to change {
        Chemtrail::Template.subclass_map
      }.from({}).to("object" => Object)
    end

    it "adds namespaced subclasses to the template map" do
      expect {
        Chemtrail::Template.send(:inherited, Chemtrail::Template)
      }.to change {
        Chemtrail::Template.subclass_map
      }.from({}).to("chemtrail:template" => Chemtrail::Template)
    end

    it "adds camelcased subclasses to the template map as snakecase" do
      expect {
        Chemtrail::Template.send(:inherited, Chemtrail::PropertyList)
      }.to change {
        Chemtrail::Template.subclass_map
      }.from({}).to("chemtrail:property_list" => Chemtrail::PropertyList)
    end
  end
end
