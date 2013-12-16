require "spec_helper"

describe Chemtrail::Output do
  let(:value) { "delicious" }

  subject(:output) { Chemtrail::Output.new("chocolate", value) }

  its(:id) { should == "chocolate" }
  its(:value) { should == "delicious" }

  context "when the value is a literal" do
    its(:value_parameter) { should == "delicious" }
  end

  context "when the value is a reference" do
    let(:value) { double(:value, to_reference: "nom") }

    its(:value_parameter) { should == "nom" }
  end

  context "when no description is provided" do
    its(:description) { should be_nil }
    its(:description_hash) { should be_empty }
  end

  context "when a description is provided" do
    subject(:output) { Chemtrail::Output.new("chocolate", "nast", "wat") }

    its(:description) { should == "wat" }
    its(:description_hash) { should == {"Description" => "wat"} }
  end

  describe "#to_hash" do
    its(:to_hash) { should == {"chocolate" => {"Value"=>"delicious"}} }
  end
end
