require "chemtrail"
require "yaml"

class OpsworksVpc < Chemtrail::Template
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
    [
      Chemtrail::Parameter.new("NATInstanceType", "String", parameters_config["NATInstanceType"])
    ]
  end

  def mappings
    [
      Chemtrail::Mapping.new("AWSNATAMI", mappings_config["AWSNATAMI"]),
      Chemtrail::Mapping.new("AWSInstanceType2Arch", mappings_config["AWSInstanceType2Arch"]),
      subnet_config
    ]
  end

  def resources
    [
      vpc,
      public_subnet,
      internet_gateway,
      gateway_to_internet
    ]
  end

  def subnet_config
    @subnet_config ||= Chemtrail::Mapping.new("SubnetConfig", mappings_config["SubnetConfig"])
  end

  def vpc
    @vpc ||= Chemtrail::Resource.new("VPC", "AWS::EC2::VPC", resources_config["VPC"]).tap do |config|
      config.properties["CidrBlock"] = subnet_config.find("VPC", "CIDR")
      config.properties["Tags"] << stack_name.as_tag("Application")
    end
  end

  def public_subnet
    @public_subnet ||= Chemtrail::Resource.new("PublicSubnet", "AWS::EC2::Subnet", resources_config["PublicSubnet"]).tap do |config|
      config.properties["VpcId"] = vpc
      config.properties["CidrBlock"] = subnet_config.find("VPC", "CIDR")
      config.properties["Tags"] << stack_name.as_tag("Application")
    end
  end

  def internet_gateway
    @internet_gateway ||= Chemtrail::Resource.new("InternetGateway", "AWS::EC2::InternetGateway", resources_config["InternetGateway"]).tap do |config|
      config.properties["Tags"] << stack_name.as_tag("Application")
    end
  end

  def gateway_to_internet
    @gateway_to_internet ||= Chemtrail::Resource.new("GatewayToInternet", "AWS::EC2::VPCGatewayAttachment", resources_config["GatewayToInternet"]).tap do |config|
      config.properties["VpcId"] = vpc
      config.properties["InternetGatewayId"] = internet_gateway
    end
  end

  def stack_name
    @stack_name ||= Chemtrail::Intrinsic.new("AWS::StackName")
  end

  protected

  def parameters_config
    @parameters_config ||= YAML.load_file(File.expand_path("../config/parameters.yml", __FILE__))
  end

  def mappings_config
    @mappings_config ||= YAML.load_file(File.expand_path("../config/mappings.yml", __FILE__))
  end

  def resources_config
    @resources_config ||= YAML.load_file(File.expand_path("../config/resources.yml", __FILE__))
  end
end
