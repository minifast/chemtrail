require "spec_helper"

describe Chemtrail::Declaration do
  subject(:declaration) { Chemtrail::Declaration.new("parmesan", "String") }

  describe "#specifications" do
    context "when there are no specifications" do
      its(:specifications) { should be_empty }
    end

    context "when a specification has been passed into the initializer" do
      subject(:declaration) { Chemtrail::Declaration.new("parmesan", "String", ok: "great") }

      its(:specifications) { should == {ok: "great"} }
    end
  end

  describe "#to_reference" do
    its(:to_reference) { should == { "Ref" => "parmesan" } }
  end

  describe "#to_hash" do
    its(:to_hash) { should have_key "parmesan" }
    specify { declaration.to_hash["parmesan"].should include("Type" => "String") }

    context "when there is a specification" do
      before { declaration.specifications[:ducks] = "amazing" }

      specify { declaration.to_hash["parmesan"].should include(ducks: "amazing") }
    end
  end
end
