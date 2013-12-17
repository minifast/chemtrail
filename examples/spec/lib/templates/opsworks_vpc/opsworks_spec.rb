require "spec_helper"

describe OpsworksVpc::Opsworks do
  let(:vpc) { double(:vpc, id: "VPC") }
  let(:elb_security_group) { double(:elb_security_group, id: "LoadBalancerSecurityGroup") }

  subject(:opsworks) { OpsworksVpc::Opsworks.new(vpc, elb_security_group) }

  describe "#resources" do
    its(:resources) { should have_resource("OpsWorksSecurityGroup").with_type("AWS::EC2::SecurityGroup") }

    describe "OpsWorksSecurityGroup" do
      let(:ingress) { opsworks.security_group.properties["SecurityGroupIngress"].first }

      its(:security_group) { should have_property("VpcId").with_reference("VPC") }
      its(:security_group) { should have_property("SecurityGroupIngress") }

      specify { ingress["SourceSecurityGroupId"].should be_reference_to("LoadBalancerSecurityGroup") }
    end
  end
end
