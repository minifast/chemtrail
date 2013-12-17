require "spec_helper"

describe OpsworksVpc::PrivateNetwork do
  let(:vpc) { double(:vpc, id: "VPC") }
  let(:nat_device) { double(:nat_device, id: "NATDevice") }
  let(:subnet) { double(:subnet, find: "found") }

  subject(:network) { OpsworksVpc::PrivateNetwork.new(vpc, subnet, nat_device) }

  describe "#resources" do
    its(:resources) { should have_resource("PrivateSubnet").with_type("AWS::EC2::Subnet") }
    its(:resources) { should have_resource("PrivateRouteTable").with_type("AWS::EC2::RouteTable") }
    its(:resources) { should have_resource("PrivateRoute").with_type("AWS::EC2::Route") }
    its(:resources) { should have_resource("PrivateSubnetRouteTableAssociation").with_type("AWS::EC2::SubnetRouteTableAssociation") }
    its(:resources) { should have_resource("PrivateNetworkAcl").with_type("AWS::EC2::NetworkAcl") }
    its(:resources) { should have_resource("PrivateSubnetNetworkAclAssociation").with_type("AWS::EC2::SubnetNetworkAclAssociation") }
    its(:resources) { should have_resource("InboundPrivateNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }
    its(:resources) { should have_resource("OutBoundPrivateNetworkAclEntry").with_type("AWS::EC2::NetworkAclEntry") }

    describe "PrivateSubnet" do
      its(:subnet) { should have_property("CidrBlock") }
      its(:subnet) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "PrivateRouteTable" do
      its(:route_table) { should have_property("VpcId").with_reference("VPC") }
      its(:route_table) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "PrivateRoute" do
      its(:route) { should have_property("RouteTableId").with_reference("PrivateRouteTable") }
      its(:route) { should have_property("InstanceId").with_reference("NATDevice") }
    end

    describe "PrivateSubnetRouteTableAssociation" do
      its(:subnet_route_table_association) { should have_property("RouteTableId").with_reference("PrivateRouteTable") }
      its(:subnet_route_table_association) { should have_property("SubnetId").with_reference("PrivateSubnet") }
    end

    describe "PrivateNetworkAcl" do
      its(:network_acl) { should have_property("VpcId").with_reference("VPC") }
      its(:network_acl) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "PrivateSubnetNetworkAclAssociation" do
      its(:network_acl_association) { should have_property("SubnetId").with_reference("PrivateSubnet") }
      its(:network_acl_association) { should have_property("NetworkAclId").with_reference("PrivateNetworkAcl") }
    end

    describe "InboundPrivateNetworkAclEntry" do
      its(:inbound_entry) { should have_property("NetworkAclId").with_reference("PrivateNetworkAcl") }
      its(:inbound_entry) { should have_property("PortRange").with_value("From" => "0", "To" => "65535") }
      its(:inbound_entry) { should have_property("Egress").with_value("false") }
    end

    describe "OutBoundPrivateNetworkAclEntry" do
      its(:outbound_entry) { should have_property("NetworkAclId").with_reference("PrivateNetworkAcl") }
      its(:outbound_entry) { should have_property("PortRange").with_value("From" => "0", "To" => "65535") }
      its(:outbound_entry) { should have_property("Egress").with_value("true") }
    end
  end
end
