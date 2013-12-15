require "spec_helper"

describe Chemtrail::Section do
  let(:entry) { double(:entry, to_hash: {tacos: "great"}) }

  subject(:section) { Chemtrail::Section.new }

  describe "#to_hash" do
    before { section << entry }

    its(:to_hash) { should == {tacos: "great"} }
  end
end
