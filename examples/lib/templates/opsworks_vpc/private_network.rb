module OpsworksVpc
  class PrivateNetwork
    attr_reader :vpc, :subnet_config, :nat_device

    def initialize(vpc, subnet_config, nat_device)
      @vpc = vpc
      @subnet_config = subnet_config
      @nat_device = nat_device
    end

    def resources
      [
        subnet,
        route_table,
        route,
        subnet_route_table_association,
        network_acl,
        network_acl_association,
        inbound_entry,
        outbound_entry
      ]
    end

    def subnet
      @subnet ||= Chemtrail::Resource.new("PrivateSubnet", "AWS::EC2::Subnet", resources_config["PrivateSubnet"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["CidrBlock"] = subnet_config.find("Private", "CIDR")
        config.properties["Tags"] << stack_name.as_tag("Application")
      end
    end

    def route_table
      @route_table ||= Chemtrail::Resource.new("PrivateRouteTable", "AWS::EC2::RouteTable", resources_config["PrivateRouteTable"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["Tags"] << stack_name.as_tag("Application")
      end
    end

    def route
      @route ||= Chemtrail::Resource.new("PrivateRoute", "AWS::EC2::Route", resources_config["PrivateRoute"]).tap do |config|
        config.properties["RouteTableId"] = route_table
        config.properties["InstanceId"] = nat_device
      end
    end

    def subnet_route_table_association
      @subnet_route_table_association ||= Chemtrail::Resource.new("PrivateSubnetRouteTableAssociation", "AWS::EC2::SubnetRouteTableAssociation", resources_config["PrivateSubnetRouteTableAssociation"]).tap do |config|
        config.properties["RouteTableId"] = route_table
        config.properties["SubnetId"] = subnet
      end
    end

    def network_acl
      @network_acl ||= Chemtrail::Resource.new("PrivateNetworkAcl", "AWS::EC2::NetworkAcl", resources_config["PrivateNetworkAcl"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["Tags"] << stack_name.as_tag("Application")
      end
    end

    def network_acl_association
      @network_acl_association ||= Chemtrail::Resource.new("PrivateSubnetNetworkAclAssociation", "AWS::EC2::SubnetNetworkAclAssociation", resources_config["PrivateSubnetNetworkAclAssociation"]).tap do |config|
        config.properties["SubnetId"] = subnet
        config.properties["NetworkAclId"] = network_acl
      end
    end

    def inbound_entry
      @inbound_entry ||= Chemtrail::Resource.new("InboundPrivateNetworkAclEntry", "AWS::EC2::NetworkAclEntry", resources_config["InboundPrivateNetworkAclEntry"]).tap do |config|
        config.properties["NetworkAclId"] = network_acl
      end
    end

    def outbound_entry
      @outbound_entry ||= Chemtrail::Resource.new("OutBoundPrivateNetworkAclEntry", "AWS::EC2::NetworkAclEntry", resources_config["OutBoundPrivateNetworkAclEntry"]).tap do |config|
        config.properties["NetworkAclId"] = network_acl
      end
    end

    protected

    def stack_name
      @stack_name ||= Chemtrail::Intrinsic.new("AWS::StackName")
    end

    def resources_config
      @resources_config ||= YAML.load_file(File.expand_path("../../config/private_network.yml", __FILE__))
    end
  end
end
