module OpsworksVpc
  class LoadBalancer
    attr_reader :vpc, :public_subnet

    def initialize(vpc, public_subnet)
      @vpc = vpc
      @public_subnet = public_subnet
    end

    def resources
      [
        security_group,
        elb
      ]
    end

    def security_group
      @security_group ||= Chemtrail::Resource.new("LoadBalancerSecurityGroup", "AWS::EC2::SecurityGroup", resources_config["LoadBalancerSecurityGroup"]).tap do |config|
        config.properties["VpcId"] = vpc
      end
    end

    def elb
      @elb ||= Chemtrail::Resource.new("ElasticLoadBalancer", "AWS::ElasticLoadBalancing::LoadBalancer", resources_config["ElasticLoadBalancer"]).tap do |config|
        config.properties["Subnets"] = [public_subnet]
        config.properties["SecurityGroups"] = [security_group]
      end
    end

    protected

    def resources_config
      @resources_config ||= YAML.load_file(File.expand_path("../../config/load_balancer.yml", __FILE__))
    end
  end
end
