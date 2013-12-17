module OpsworksVpc
  class Opsworks
    attr_reader :vpc, :elb_security_group

    def initialize(vpc, elb_security_group)
      @vpc = vpc
      @elb_security_group = elb_security_group
    end

    def resources
      [security_group]
    end

    def security_group
      @security_group ||= Chemtrail::Resource.new("OpsWorksSecurityGroup", "AWS::EC2::SecurityGroup", resources_config["OpsWorksSecurityGroup"]).tap do |config|
        config.properties["VpcId"] = vpc
        config.properties["SecurityGroupIngress"].first["SourceSecurityGroupId"] = elb_security_group
      end
    end

    protected

    def resources_config
      @resources_config ||= YAML.load_file(File.expand_path("../../config/opsworks.yml", __FILE__))
    end
  end
end
