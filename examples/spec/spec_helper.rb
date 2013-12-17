$:<< File.expand_path("../../../lib", __FILE__)

require "chemtrail"
require "chemtrail/rspec"
require "json"

Dir.glob(File.expand_path("../../lib/templates/**/*_template.rb", __FILE__)).each { |t| require t }

RSpec.configure do |config|
  config.include Chemtrail::RSpec
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end

