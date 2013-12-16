require "spec_helper"

describe Chemtrail::Mapping do
  subject(:mapping) { Chemtrail::Mapping.new("atlas") }

  describe "#to_hash" do
    context "when there are no entries" do
      its(:to_hash) { should == {"atlas" => {}} }
    end

    context "when an entry has been added" do
      before { mapping.entries[:teeth] = {} }

      specify { mapping.to_hash["atlas"].should == {teeth: {}} }
    end

    context "when an entry is passed into the initializer" do
      subject(:mapping) { Chemtrail::Mapping.new("atlas", charles: {}) }

      specify { mapping.to_hash["atlas"].should == {charles: {}} }
    end
  end

  describe "#find" do
    context "when all parameters are strings" do
      let(:finder) { mapping.find("usa", "tacos") }

      specify { finder["Fn::FindInMap"].should == ["atlas", "usa", "tacos"] }
    end

    context "when the first parameter is a declaration" do
      let(:fake_declaration) { double(:declaration, to_reference: "fake eyes") }
      let(:finder) { mapping.find(fake_declaration, "gag shop") }

      specify { finder["Fn::FindInMap"].should == ["atlas", "fake eyes", "gag shop"] }
    end

    context "when the second parameter is a declaration" do
      let(:fake_declaration) { double(:declaration, to_reference: "wheelbarrow") }
      let(:finder) { mapping.find("pasta", fake_declaration) }

      specify { finder["Fn::FindInMap"].should == ["atlas", "pasta", "wheelbarrow"] }
    end
  end
end
