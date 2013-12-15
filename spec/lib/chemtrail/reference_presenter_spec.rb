require "spec_helper"

describe Chemtrail::ReferencePresenter do
  subject(:presenter) { Chemtrail::ReferencePresenter.new(argument) }

  context "when the argument is a string literal" do
    let(:argument) { "literal" }

    it { should_not be_reference }
    its(:to_parameter) { should == "literal"}
  end

  context "when the argument can resolve into a reference" do
    let(:argument) { double(:argument, to_reference: "reference") }

    it { should be_reference }
    its(:to_parameter) { should == "reference" }
  end
end
