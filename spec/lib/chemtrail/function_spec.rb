require "spec_helper"

describe Chemtrail::Function do
  let(:arguments) { [] }

  subject(:function) { Chemtrail::Function.new("BrushTeeth", *arguments) }

  its(:name) { should == "BrushTeeth" }
  its(:arguments) { should be_empty }

  context "when the function gets no arguments" do
    its(:argument_list) { should be_empty }
    its(:to_hash) { should == { "BrushTeeth" => "" } }
  end

  context "when the function gets a single argument" do
    let(:arguments) { ["tasty"] }

    its(:argument_list) { should == ["tasty"] }
    its(:to_hash) { should == { "BrushTeeth" => "tasty" } }
  end

  context "when the function gets multiple arguments" do
    let(:arguments) { ["orange", "juice"] }

    its(:argument_list) { should == ["orange", "juice"] }
    its(:to_hash) { should == { "BrushTeeth" => ["orange", "juice"] } }
  end

  context "when the function has a reference argument" do
    let(:arguments) { [double(:argument, to_reference: "flossing")] }

    its(:argument_list) { should == ["flossing"] }
    its(:to_hash) { should == { "BrushTeeth" => "flossing" } }
  end
end
