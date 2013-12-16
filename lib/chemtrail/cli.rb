require "thor"
require "json"
require "chemtrail"

class Chemtrail::Cli < Thor
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
    require_templates_from(options[:path])
    template_class = fetch_template_class_named(template_name)
    template_json = JSON.pretty_generate(template_class.new.to_hash)
    Kernel.puts(template_json)
  end

  protected

  def require_templates_from(path)
    Dir.glob(File.expand_path("**/*_template.rb", path)).each { |t| require t }
  end

  def fetch_template_class_named(name)
    template = Chemtrail::Template.subclass_map[name]
    raise Thor::Error.new("Template #{name} does not exist") if template.nil?
    template
  end
end
