module OpsworksVpc
  class PublicNetworkAcl
    attr_reader :vpc, :subnet

    def initialize(vpc, subnet)
      @vpc = vpc
      @subnet = subnet
    end

    def resources
      [
        network_acl,
        network_acl_association,
        http_entry,
        https_entry,
        ssh_entry,
        ephemeral_entry,
        outbound_entry
      ]
    end

    def network_acl
      @network_acl ||= Chemtrail::Resource.new("PublicNetworkAcl", "AWS::EC2::NetworkAcl", resources_config["PublicNetworkAcl"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["Tags"] << stack_name.as_tag("Application")
      end
    end

    def network_acl_association
      @network_acl_association ||= Chemtrail::Resource.new("PublicSubnetNetworkAclAssociation", "AWS::EC2::SubnetNetworkAclAssociation", resources_config["PublicSubnetNetworkAclAssociation"]).tap do |config|
        config.properties["SubnetId"] = subnet
        config.properties["NetworkAclId"] = network_acl
      end
    end

    def http_entry
      @http_entry ||= acl_entry("InboundHTTPPublicNetworkAclEntry")
    end

    def https_entry
      @https_entry ||= acl_entry("InboundHTTPSPublicNetworkAclEntry")
    end

    def ssh_entry
      @ssh_entry ||= acl_entry("InboundSSHPublicNetworkAclEntry")
    end

    def ephemeral_entry
      @ephemeral_entry ||= acl_entry("InboundEmphemeralPublicNetworkAclEntry")
    end

    def outbound_entry
      @outbound_entry ||= acl_entry("OutboundPublicNetworkAclEntry")
    end

    protected

    def acl_entry(id)
      config = resources_config[id]
      config.merge!("NetworkAclId" => network_acl)
      Chemtrail::Resource.new(id, "AWS::EC2::NetworkAclEntry", config)
    end

    def stack_name
      @stack_name ||= Chemtrail::Intrinsic.new("AWS::StackName")
    end

    def resources_config
      @resources_config ||= YAML.load_file(File.expand_path("../../config/public_network_acl.yml", __FILE__))
    end
  end
end
