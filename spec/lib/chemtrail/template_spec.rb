require "spec_helper"

describe Chemtrail::Template do
  let(:fake_mapping) { double(:mapping, to_hash: {"mapping" => "json"}) }
  let(:fake_output) { double(:output, to_hash: {"output" => "json"}) }
  let(:fake_parameter) { double(:parameter, to_hash: {"parameter" => "json"}) }
  let(:fake_resource) { double(:resource, to_hash: {"resource" => "json"}) }

  subject(:template) { Chemtrail::Template.new("wat") }

  describe "#parameters" do
    context "when the template has parameters" do
      before { template.parameters << fake_parameter }

      its(:parameters) { should =~ [fake_parameter] }
    end

    context "when the template does not have parameters" do
      its(:parameters) { should be_empty }
    end
  end

  describe "#mappings" do
    context "when the template has mappings" do
      before { template.mappings << fake_mapping }

      its(:mappings) { should == [fake_mapping] }
    end

    context "when the template does not have mappings" do
      its(:mappings) { should be_empty }
    end
  end

  describe "#resources" do
    context "when the template has resources" do
      before { template.resources << fake_resource }

      its(:resources) { should == [fake_resource] }
    end

    context "when the template does not have resources" do
      its(:resources) { should be_empty }
    end
  end

  describe "#outputs" do
    context "when the template has outputs" do
      before { template.outputs << fake_output }

      its(:outputs) { should == [fake_output] }
    end

    context "when the template does not have outputs" do
      its(:outputs) { should be_empty }
    end
  end

  describe "#to_hash" do
    its(:to_hash) { should include("AWSTemplateFormatVersion" => "2010-09-09") }
    its(:to_hash) { should include("Description" => "wat") }
    its(:to_hash) { should have_key "Parameters" }
    its(:to_hash) { should have_key "Mappings" }
    its(:to_hash) { should have_key "Resources" }
    its(:to_hash) { should have_key "Outputs" }

    context "when the template has parameters" do
      before { template.parameters << fake_parameter }

      its(:to_hash) { should include("Parameters" => {"parameter" => "json"}) }
    end

    context "when the template has mappings" do
      before { template.mappings << fake_mapping }

      its(:to_hash) { should include("Mappings" => {"mapping" => "json"}) }
    end

    context "when the template has resources" do
      before { template.resources << fake_resource }

      its(:to_hash) { should include("Resources" => {"resource" => "json"}) }
    end

    context "when the template has outputs" do
      before { template.outputs << fake_output }

      its(:to_hash) { should include("Outputs" => {"output" => "json"}) }
    end
  end
end
