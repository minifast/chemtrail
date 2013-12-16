require "spec_helper"

describe Chemtrail::SectionPresenter do
  let(:entry) { double(:entry, to_hash: {tacos: "great"}) }
  let(:entries) { [] }

  subject(:section) { Chemtrail::SectionPresenter.new("Socks", entries) }

  describe "#to_hash" do
    context "when there are no entries" do
      let(:entries) { [] }

      its(:to_hash) { should == {} }
    end

    context "when there is an entry" do
      let(:entries) { [entry] }

      its(:to_hash) { should == {"Socks" => {tacos: "great"}} }
    end
  end
end
