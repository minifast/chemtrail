require "spec_helper"

describe Chemtrail::ReferencePresenter do
  let(:fake_reference) { double(:argument, to_reference: "reference") }

  subject(:presenter) { Chemtrail::ReferencePresenter.new(argument) }

  context "when the argument is a string literal" do
    let(:argument) { "literal" }

    it { should_not be_reference }
    it { should_not be_iterable }
    it { should_not be_hashlike }
    its(:to_parameter) { should == "literal"}
  end

  context "when the argument can resolve into a reference" do
    let(:argument) { fake_reference }

    it { should be_reference }
    it { should_not be_iterable }
    it { should_not be_hashlike }
    its(:to_parameter) { should == "reference" }
  end

  context "when the argument contains a nested reference" do
    let(:argument) { [fake_reference] }

    it { should_not be_reference }
    it { should be_iterable }
    it { should_not be_hashlike }
    its(:to_parameter) { should == ["reference"] }
  end

  context "when the argument contains a nested reference in a hash" do
    let(:argument) { {"key" => fake_reference} }

    it { should_not be_reference }
    it { should be_iterable }
    it { should be_hashlike }
    its(:to_parameter) { should == {"key" => "reference"} }
  end
end
