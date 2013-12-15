# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chemtrail/version'

Gem::Specification.new do |spec|
  spec.name          = "chemtrail"
  spec.version       = Chemtrail::VERSION
  spec.authors       = ["Doc Ritezel"]
  spec.email         = ["pair+doc@ministryofvelocity.com"]
  spec.description   = %q{Seed your CloudFormation stack}
  spec.summary       = %q{Build, create and maintain your CloudFormation stack}
  spec.homepage      = "https://github.com/minifast/chemtrail"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk-core"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "gem-release"
  spec.add_development_dependency "rspec"
end
