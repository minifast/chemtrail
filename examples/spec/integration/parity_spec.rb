require "spec_helper"

describe "parity with cloudformation" do
  let(:template_path) { File.expand_path("../../support/OpsWorksinVPC.template", __FILE__) }
  let(:template_contents) { File.read(template_path) }
  let(:template) { JSON.parse(template_contents) }
  let(:generated) { OpsworksVpc::Stack.new.to_hash }

  it "maintains parity with cloudformation" do
    template.should == generated
  end
end
