require "spec_helper"

describe OpsworksVpc::PublicNetwork do
  let(:vpc) { double(:vpc, id: "VPC") }
  let(:subnet) { double(:subnet, find: "found") }

  subject(:network) { OpsworksVpc::PublicNetwork.new(vpc, subnet) }

  describe "#resources" do
    its(:resources) { should have_resource("PublicSubnet").with_type("AWS::EC2::Subnet") }
    its(:resources) { should have_resource("InternetGateway").with_type("AWS::EC2::InternetGateway") }
    its(:resources) { should have_resource("GatewayToInternet").with_type("AWS::EC2::VPCGatewayAttachment") }
    its(:resources) { should have_resource("PublicRouteTable").with_type("AWS::EC2::RouteTable") }
    its(:resources) { should have_resource("PublicSubnetRouteTableAssociation").with_type("AWS::EC2::SubnetRouteTableAssociation") }

    describe "PublicSubnet" do
      its(:subnet) { should have_property("CidrBlock") }
      its(:subnet) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "InternetGateway" do
      its(:internet_gateway) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "GatewayToInternet" do
      its(:gateway_to_internet) { should have_property("VpcId").with_reference("VPC") }
      its(:gateway_to_internet) { should have_property("InternetGatewayId").with_reference("InternetGateway") }
    end

    describe "PublicRouteTable" do
      its(:route_table) { should have_property("VpcId").with_reference("VPC") }
      its(:route_table) { should have_tag("Application").with_reference("AWS::StackName") }
    end

    describe "PublicSubnetRouteTableAssociation" do
      its(:route_table_association) { should have_property("SubnetId").with_reference("PublicSubnet") }
      its(:route_table_association) { should have_property("RouteTableId").with_reference("PublicRouteTable") }
    end
  end
end
