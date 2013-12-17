require "spec_helper"

describe OpsworksVpc::NatDevice do
  let(:vpc) { double(:vpc, id: "VPC") }
  let(:nat_instance_type) { double(:nat_instance_type, id: "NATInstanceType") }
  let(:public_subnet) { double(:public_subnet, id: "PublicSubnet") }
  let(:opsworks_security_group) { double(:opsworks_security_group, id: "OpsWorksSecurityGroup") }

  subject(:nat_device) { OpsworksVpc::NatDevice.new(vpc, public_subnet, opsworks_security_group, nat_instance_type) }

  describe "#mappings" do
    its(:mappings) { should have_mapping "AWSNATAMI" }

    describe "AWSNATAMI" do
      its(:nat_ami) { should have_entry("us-east-1").including("AMI" =>"ami-c6699baf") }
    end
  end

  describe "#resources" do
    its(:resources) { should have_resource("NATSecurityGroup").with_type("AWS::EC2::SecurityGroup") }
    its(:resources) { should have_resource("NATDevice").with_type("AWS::EC2::Instance") }
    its(:resources) { should have_resource("NATIPAddress").with_type("AWS::EC2::EIP") }

    describe "NATSecurityGroup" do
      its(:security_group) { should have_property("VpcId").with_reference("VPC") }

      it "references the opsworks security group on all ingress rules" do
        nat_device.security_group.properties["SecurityGroupIngress"].each do |rule|
          rule["SourceSecurityGroupId"].should be_reference_to("OpsWorksSecurityGroup")
        end
      end
    end

    describe "NATDevice" do
      its(:device) { should have_property("InstanceType").with_reference("NATInstanceType") }
      its(:device) { should have_property("SubnetId").with_reference("PublicSubnet") }
      its(:device) { should have_property("ImageId") }
      its(:device) { should have_property("SecurityGroupIds").including_reference("NATSecurityGroup") }
    end

    describe "NATIPAddress" do
      its(:ip) { should have_property("InstanceId").with_reference("NATDevice") }
    end
  end
end
