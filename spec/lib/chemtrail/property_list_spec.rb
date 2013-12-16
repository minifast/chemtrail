require "spec_helper"

describe Chemtrail::PropertyList do
  let(:fake_entry) { double(:entry, to_reference: "zuul") }

  subject(:list) { Chemtrail::PropertyList.new }

  context "when the list contains a literal" do
    before { list[:ghostbusters] = "light's green, trap's clean" }

    its(:to_hash) { should == {ghostbusters: "light's green, trap's clean"} }
  end

  context "when the list contains a reference" do
    before { list[:ghostbusters] = fake_entry }

    its(:to_hash) { should == {ghostbusters: "zuul"} }
  end

  context "when the list contains a nested reference" do
    before { list[:ghostbusters] = {gatekeeper: "zuul"} }

    its(:to_hash) { should == {ghostbusters: {gatekeeper: "zuul"}} }
  end
end
