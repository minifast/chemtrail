require "spec_helper"

describe OpsworksVpc do
  subject(:template) { OpsworksVpc.new }

  its(:description) { should include("VPC environment for AWS OpsWorks") }

  describe "#parameters" do
    it { should have_parameter("NATInstanceType").with_type("String") }

    it { should have_field("Default").with_value("m1.small").on("NATInstanceType") }
    it { should have_field("AllowedValues").including("t1.micro").on("NATInstanceType") }
    it { should have_field("ConstraintDescription").including("valid EC2 instance").on("NATInstanceType") }
  end

  describe "#mappings" do
    it { should have_mapping("AWSNATAMI") }
    it { should have_mapping("AWSInstanceType2Arch") }
    it { should have_mapping("SubnetConfig") }

    it { should have_mapping_key("us-east-1").including("AMI" => "ami-c6699baf").on("AWSNATAMI") }
    it { should have_mapping_key("m1.medium").including("Arch" => "64").on("AWSInstanceType2Arch") }
    it { should have_mapping_key("VPC").including("CIDR" => "10.0.0.0/16").on("SubnetConfig") }
    it { should have_mapping_key("Public").including("CIDR" => "10.0.0.0/24").on("SubnetConfig") }
    it { should have_mapping_key("Private").including("CIDR" => "10.0.1.0/24").on("SubnetConfig") }
  end

  describe "#resources" do
  end
end
