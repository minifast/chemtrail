require "spec_helper"

describe Chemtrail::Intrinsic do
  subject(:intrinsic) { Chemtrail::Intrinsic.new("Tacos") }

  its(:id) { should == "Tacos" }
  its(:to_reference) { should == {"Ref" => "Tacos"} }

  describe "#as_tag" do
    it "creates a tag with the given name" do
      intrinsic.as_tag("Great").should == {"Key"=>"Great", "Value"=>intrinsic}
    end
  end
end
