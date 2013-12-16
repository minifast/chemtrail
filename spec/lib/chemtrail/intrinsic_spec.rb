require "spec_helper"

describe Chemtrail::Intrinsic do
  subject(:intrinsic) { Chemtrail::Intrinsic.new("Tacos") }

  its(:id) { should == "Tacos" }
  its(:to_reference) { should == {"Ref" => "Tacos"} }
end
