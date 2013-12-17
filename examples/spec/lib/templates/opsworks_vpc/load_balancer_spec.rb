require "spec_helper"

describe OpsworksVpc::LoadBalancer do
  let(:vpc) { double(:vpc, id: "VPC") }
  let(:public_subnet) { double(:public_subnet, id: "PublicSubnet") }

  subject(:elb) { OpsworksVpc::LoadBalancer.new(vpc, public_subnet) }

  describe "#resources" do
    its(:resources) { should have_resource("LoadBalancerSecurityGroup").with_type("AWS::EC2::SecurityGroup") }
    its(:resources) { should have_resource("ElasticLoadBalancer").with_type("AWS::ElasticLoadBalancing::LoadBalancer") }

    describe "LoadBalancerSecurityGroup" do
      its(:security_group) { should have_property("VpcId").with_reference("VPC") }
    end

    describe "ElasticLoadBalancer" do
      its(:elb) { should have_property("SecurityGroups").including_reference("LoadBalancerSecurityGroup") }
      its(:elb) { should have_property("Subnets").including_reference("PublicSubnet") }
    end
  end
end
