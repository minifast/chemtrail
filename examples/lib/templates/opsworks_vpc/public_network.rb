require_relative "public_network_acl"

module OpsworksVpc
  class PublicNetwork
    attr_reader :vpc, :subnet_config

    def initialize(vpc, subnet_config)
      @vpc = vpc
      @subnet_config = subnet_config
    end

    def resources
      [
        subnet,
        internet_gateway,
        gateway_to_internet,
        route_table,
        route,
        route_table_association
      ] + network_acl.resources
    end

    def subnet
      @subnet ||= Chemtrail::Resource.new("PublicSubnet", "AWS::EC2::Subnet", resources_config["PublicSubnet"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["CidrBlock"] = subnet_config.find("Public", "CIDR")
        config.properties["Tags"].unshift(stack_name.as_tag("Application"))
      end
    end

    def internet_gateway
      @internet_gateway ||= Chemtrail::Resource.new("InternetGateway", "AWS::EC2::InternetGateway", resources_config["InternetGateway"]).tap do |config|
        config.properties["Tags"].unshift(stack_name.as_tag("Application"))
      end
    end

    def gateway_to_internet
      @gateway_to_internet ||= Chemtrail::Resource.new("GatewayToInternet", "AWS::EC2::VPCGatewayAttachment", resources_config["GatewayToInternet"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["InternetGatewayId"] = internet_gateway
      end
    end

    def route_table
      @route_table ||= Chemtrail::Resource.new("PublicRouteTable", "AWS::EC2::RouteTable", resources_config["PublicRouteTable"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["Tags"].unshift(stack_name.as_tag("Application"))
      end
    end

    def route
      @route ||= Chemtrail::Resource.new("PublicRoute", "AWS::EC2::Route", resources_config["PublicRoute"]).tap do |config|
        config.properties["RouteTableId"] = route_table
        config.properties["GatewayId"] = internet_gateway
      end
    end

    def route_table_association
      @route_table_association ||= Chemtrail::Resource.new("PublicSubnetRouteTableAssociation", "AWS::EC2::SubnetRouteTableAssociation", resources_config["PublicSubnetRouteTableAssociation"]).tap do |config|
        config.properties["RouteTableId"] = route_table
        config.properties["SubnetId"] = subnet
      end
    end

    def network_acl
      @network_acl ||= OpsworksVpc::PublicNetworkAcl.new(vpc, subnet)
    end

    protected

    def stack_name
      @stack_name ||= Chemtrail::Intrinsic.new("AWS::StackName")
    end

    def resources_config
      @resources_config ||= YAML.load_file(File.expand_path("../../config/public_network.yml", __FILE__))
    end
  end
end
