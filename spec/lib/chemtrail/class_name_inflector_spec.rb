require "spec_helper"

describe Chemtrail::ClassNameInflector do
  subject(:inflector) { Chemtrail::ClassNameInflector.new(class_name) }

  describe "#underscore" do
    context "with a normal name" do
      let(:class_name) { "Tacos" }

      its(:underscore) { should == "tacos" }
    end

    context "with a normal camelcase name" do
      let(:class_name) { "ZapZap" }

      its(:underscore) { should == "zap_zap" }
    end

    context "with a slightly abnormal camelcase name" do
      let(:class_name) { "DSLAreGreat" }

      its(:underscore) { should == "dsl_are_great" }
    end

    context "with a namespace" do
      let(:class_name) { "Geese::Adorable" }

      its(:underscore) { should == "geese:adorable" }
    end
  end
end
