module OpsworksVpc
  class NatDevice
    attr_reader :vpc, :public_subnet, :opsworks_security_group, :nat_instance_type

    def initialize(vpc, public_subnet, opsworks_security_group, nat_instance_type)
      @vpc = vpc
      @public_subnet = public_subnet
      @opsworks_security_group = opsworks_security_group
      @nat_instance_type = nat_instance_type
    end

    def mappings
      [nat_ami]
    end

    def resources
      [security_group, device, ip]
    end

    def nat_ami
      @nat_ami ||= Chemtrail::Mapping.new("AWSNATAMI", nat_device_config["AWSNATAMI"])
    end

    def device
      @device ||= Chemtrail::Resource.new("NATDevice", "AWS::EC2::Instance", nat_device_config["NATDevice"]).tap do |config|
        config.properties["InstanceType"] = nat_instance_type
        config.properties["SubnetId"] = public_subnet
        config.properties["ImageId"] = nat_ami.find(region, "AMI")
        config.properties["SecurityGroupIds"] = [security_group]
      end
    end

    def ip
      @ip ||= Chemtrail::Resource.new("NATIPAddress", "AWS::EC2::EIP", nat_device_config["NATIPAddress"]).tap do |config|
        config.properties["InstanceId"] = device
      end
    end

    def security_group
      @security_group ||= Chemtrail::Resource.new("NATSecurityGroup", "AWS::EC2::SecurityGroup", nat_device_config["NATSecurityGroup"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["SecurityGroupIngress"].each do |group|
          group["SourceSecurityGroupId"] = opsworks_security_group
        end
      end
    end

    protected

    def region
      @region ||= Chemtrail::Intrinsic.new("AWS::Region")
    end

    def nat_device_config
      @nat_device_config ||= YAML.load_file(File.expand_path("../../config/nat_device.yml", __FILE__))
    end
  end
end
