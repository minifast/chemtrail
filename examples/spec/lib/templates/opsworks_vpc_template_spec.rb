require "spec_helper"

describe OpsworksVpc::Stack do
  subject(:template) { OpsworksVpc::Stack.new }

  its(:description) { should include("VPC environment for AWS OpsWorks") }

  describe "#parameters" do
    its(:parameters) { should have_parameter("NATInstanceType").with_type("String") }

    describe "NATInstanceType" do
      its(:nat_instance_type) { should have_field("Default").with_value("m1.small") }
      its(:nat_instance_type) { should have_field("AllowedValues").including("t1.micro") }
      its(:nat_instance_type) { should have_field("ConstraintDescription").including("valid EC2 instance") }
    end
  end

  describe "#mappings" do
    its(:mappings) { should have_mapping "AWSNATAMI" }
    its(:mappings) { should have_mapping "AWSInstanceType2Arch" }
    its(:mappings) { should have_mapping "SubnetConfig" }

    describe "AWSInstanceType2Arch" do
      its(:instance_type_arch) { should have_entry("m1.medium").including("Arch" => "64") }
    end

    describe "SubnetConfig" do
      its(:subnet_config) { should have_entry("VPC").including("CIDR" => "10.0.0.0/16") }
      its(:subnet_config) { should have_entry("Public").including("CIDR" => "10.0.0.0/24") }
      its(:subnet_config) { should have_entry("Private").including("CIDR" => "10.0.1.0/24") }
    end
  end

  describe "#resources" do
    its(:resources) { should have_resource "OpsWorksSecurityGroup" }
    its(:resources) { should have_resource "NATDevice" }
    its(:resources) { should have_resource "ElasticLoadBalancer" }
    its(:resources) { should have_resource "PrivateSubnet" }
    its(:resources) { should have_resource "PublicSubnet" }
    its(:resources) { should have_resource "InboundHTTPPublicNetworkAclEntry" }

    its(:resources) { should have_resource("VPC").with_type("AWS::EC2::VPC") }

    describe "VPC" do
      its(:vpc) { should have_property("CidrBlock") }
      its(:vpc) { should have_tag("Application").with_reference("AWS::StackName") }
      its(:vpc) { should have_tag("Network").with_value("Public") }
    end
  end

  describe "#outputs" do
    its(:outputs) { should have_output("VPC").with_reference("VPC") }
    its(:outputs) { should have_output("PublicSubnets").with_reference("PublicSubnet") }
    its(:outputs) { should have_output("PrivateSubnets").with_reference("PrivateSubnet") }
    its(:outputs) { should have_output("LoadBalancer").with_reference("ElasticLoadBalancer") }
  end
end
