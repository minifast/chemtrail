require "spec_helper"

describe OpsworksVpc::PublicNetworkAcl do
  let(:vpc) { double(:vpc, id: "VPC") }
  let(:subnet) { double(:subnet, id: "PublicSubnet") }

  subject(:network) { OpsworksVpc::PublicNetworkAcl.new(vpc, subnet) }

  describe "#resources" do
    its(:resources) { should have_resource("PublicNetworkAcl").with_type("AWS::EC2::NetworkAcl") }
    its(:resources) { should have_resource("PublicSubnetNetworkAclAssociation").with_type("AWS::EC2::SubnetNetworkAclAssociation") }
    its(:resources) { should have_resource("InboundHTTPPublicNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }
    its(:resources) { should have_resource("InboundHTTPSPublicNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }
    its(:resources) { should have_resource("InboundSSHPublicNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }
    its(:resources) { should have_resource("InboundEmphemeralPublicNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }
    its(:resources) { should have_resource("OutboundPublicNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }

    describe "PublicNetworkAcl" do
      its(:network_acl) { should have_property("VpcId").with_reference("VPC") }
      its(:network_acl) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "PublicSubnetNetworkAclAssociation" do
      its(:network_acl_association) { should have_property("SubnetId").with_reference("PublicSubnet") }
      its(:network_acl_association) { should have_property("NetworkAclId").with_reference("PublicNetworkAcl") }
    end

    describe "InboundHTTPPublicNetworkAclEntry" do
      its(:http_entry) { should have_property("NetworkAclId").with_reference("PublicNetworkAcl") }
      its(:http_entry) { should have_property("PortRange").with_value("From" => "80", "To" => "80") }
      its(:http_entry) { should have_property("RuleNumber").with_value("100") }
      its(:http_entry) { should have_property("Egress").with_value("false") }
    end

    describe "InboundHTTPSPublicNetworkAclEntry" do
      its(:https_entry) { should have_property("NetworkAclId").with_reference("PublicNetworkAcl") }
      its(:https_entry) { should have_property("PortRange").with_value("From" => "443", "To" => "443") }
      its(:https_entry) { should have_property("RuleNumber").with_value("101") }
      its(:https_entry) { should have_property("Egress").with_value("false") }
    end

    describe "InboundSSHPublicNetworkAclEntry" do
      its(:ssh_entry) { should have_property("NetworkAclId").with_reference("PublicNetworkAcl") }
      its(:ssh_entry) { should have_property("PortRange").with_value("From" => "22", "To" => "22") }
      its(:ssh_entry) { should have_property("RuleNumber").with_value("102") }
      its(:ssh_entry) { should have_property("Egress").with_value("false") }
    end

    describe "InboundEmphemeralPublicNetworkAclEntry" do
      its(:ephemeral_entry) { should have_property("NetworkAclId").with_reference("PublicNetworkAcl") }
      its(:ephemeral_entry) { should have_property("PortRange").with_value("From" => "1024", "To" => "65535") }
      its(:ephemeral_entry) { should have_property("RuleNumber").with_value("103") }
      its(:ephemeral_entry) { should have_property("Egress").with_value("false") }
    end

    describe "OutboundPublicNetworkAclEntry" do
      its(:outbound_entry) { should have_property("NetworkAclId").with_reference("PublicNetworkAcl") }
      its(:outbound_entry) { should have_property("PortRange").with_value("From" => "0", "To" => "65535") }
      its(:outbound_entry) { should have_property("RuleNumber").with_value("100") }
      its(:outbound_entry) { should have_property("Egress").with_value("true") }
    end
  end
end
