require "spec_helper"

describe Chemtrail::Resource do
  subject(:resource) { Chemtrail::Resource.new("toenails", "Gross") }

  its(:id) { should == "toenails" }
  its(:type) { should == "Gross" }
  its(:to_reference) { should == { "Ref" => "toenails" } }

  context "when there are no properties" do
    its(:to_hash) { should have_key "toenails" }
    specify { resource.to_hash["toenails"].should include("Type" => "Gross") }
    specify { resource.to_hash["toenails"].should include("Properties" => {}) }
  end

  context "when there is a property" do
    let(:hash) { resource.to_hash["toenails"] }

    before { resource.properties["UserDingus"] = "whatever" }

    specify { hash["Properties"].should include("UserDingus" => "whatever") }
  end
end
