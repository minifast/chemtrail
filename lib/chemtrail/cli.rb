require "thor"
require "json"
require "chemtrail"
require "aws-sdk-core"

class Chemtrail::Cli < Thor
  attr_writer :cloud_formation

  default_task :list

  desc "list", "Lists all available templates"
  method_option :path, :default => File.expand_path("lib/templates")
  def list
    require_templates_from(options[:path])
    Chemtrail::Template.subclass_map.keys.each { |k| Kernel.puts(k) }
  end

  desc "build TEMPLATE", "Builds the selected template"
  method_option :path, :default => File.expand_path("lib/templates")
  def build(template_name)
    template_json = extract_template_json(template_name, options[:path])
    Kernel.puts(template_json)
  end

  desc "validate TEMPLATE", "Validates the selected template with AWS"
  method_option :path, :default => File.expand_path("lib/templates")
  def validate(template_name)
    template_json = extract_template_json(template_name, options[:path])
    cloud_formation.validate_template(template_body: template_json)
    Kernel.puts("Template #{template_name} is valid")
  rescue Aws::CloudFormation::Errors::ValidationError => e
    raise Thor::Error.new(e)
  end

  protected

  def extract_template_json(template_name, template_path)
    require_templates_from(template_path)
    template_class = fetch_template_class_named(template_name)
    template_instance = template_class.new
    JSON.pretty_generate(template_instance.to_hash)
  end

  def cloud_formation
    @cloud_formation ||= Aws::CloudFormation.new
  end

  def require_templates_from(path)
    Dir.glob(File.expand_path("**/*_template.rb", path)).each { |t| require t }
  end

  def fetch_template_class_named(name)
    template = Chemtrail::Template.subclass_map[name]
    raise Thor::Error.new("Template #{name} does not exist") if template.nil?
    template
  end
end
