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
      Chemtrail::Mapping.new("SubnetConfig", mappings_config["SubnetConfig"])
    ]
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
