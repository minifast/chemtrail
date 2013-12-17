require "chemtrail"
require "yaml"
require_relative "opsworks_vpc/opsworks"
require_relative "opsworks_vpc/nat_device"
require_relative "opsworks_vpc/public_network"
require_relative "opsworks_vpc/load_balancer"
require_relative "opsworks_vpc/private_network"

module OpsworksVpc
  class Stack < Chemtrail::Template
    def description
      <<-DESCRIPTION.strip.gsub!(/\s+/, ' ')
        Sample template showing how to create a VPC environment for AWS OpsWorks.
        The stack contains 2 subnets: the first subnet is public and contains the
        load balancer, a NAT device for internet access from the private subnet.
        The second subnet is private.

        You will be billed for the AWS resources used if you create a stack from
        this template.
      DESCRIPTION
    end

    def parameters
      [nat_instance_type]
    end

    def mappings
      [instance_type_arch, subnet_config] + nat.mappings
    end

    def resources
      [vpc] + public_network.resources + private_network.resources + load_balancer.resources + opsworks.resources + nat.resources
    end

    def outputs
      [
        Chemtrail::Output.new("VPC", vpc, "VPC"),
        Chemtrail::Output.new("PrivateSubnets", private_network.subnet, "Private Subnet"),
        Chemtrail::Output.new("PublicSubnets", public_network.subnet, "Public Subnet"),
        Chemtrail::Output.new("LoadBalancer", load_balancer.elb, "Load Balancer"),
      ]
    end

    def nat_instance_type
      @nat_instance_type ||= Chemtrail::Parameter.new("NATInstanceType", "String", stack_config["NATInstanceType"])
    end

    def instance_type_arch
      @instance_type_arch ||= Chemtrail::Mapping.new("AWSInstanceType2Arch", stack_config["AWSInstanceType2Arch"])
    end

    def subnet_config
      @subnet_config ||= Chemtrail::Mapping.new("SubnetConfig", stack_config["SubnetConfig"])
    end

    def vpc
      @vpc ||= Chemtrail::Resource.new("VPC", "AWS::EC2::VPC", stack_config["VPC"]).tap do |config|
        config.properties["CidrBlock"] = subnet_config.find("VPC", "CIDR")
        config.properties["Tags"].unshift(stack_name.as_tag("Application"))
      end
    end

    protected

    def nat
      @nat ||= OpsworksVpc::NatDevice.new(vpc, public_network.subnet, opsworks.security_group, nat_instance_type)
    end

    def opsworks
      @opsworks ||= OpsworksVpc::Opsworks.new(vpc, load_balancer.security_group)
    end

    def load_balancer
      @load_balancer ||= OpsworksVpc::LoadBalancer.new(vpc, public_network.subnet)
    end

    def public_network
      @public_network ||= OpsworksVpc::PublicNetwork.new(vpc, subnet_config)
    end

    def private_network
      @private_network ||= OpsworksVpc::PrivateNetwork.new(vpc, subnet_config, nat.device)
    end

    def stack_name
      @stack_name ||= Chemtrail::Intrinsic.new("AWS::StackName")
    end

    def stack_config
      @stack_config ||= YAML.load_file(File.expand_path("../config/stack.yml", __FILE__))
    end
  end
end
