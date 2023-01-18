lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "golden_kafka/version"

Gem::Specification.new do |spec|
  spec.name          = "golden_kafka"
  spec.version       = GoldenKafka::VERSION
  spec.authors       = ["Federico Moretti"]
  spec.email         = ["federico@goldbely.com"]

  spec.summary       = %q{Client on top of DeliveryBoy to push events into Kafka.}
  spec.description   = %q{DeliveryBoy based client to push events into Kafka and making sure they comply with Goldbelly's guideliness.}
  spec.homepage      = "https://github.com/Goldbely/golden_kafka"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com/goldbely"
    spec.metadata["github_repo"] = "ssh://github.com:goldbely/golden_kafka"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/Goldbely/golden_kafka"
    spec.metadata["changelog_uri"] = "https://github.com/Goldbely/golden_kafka/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # We'll fix backwards compatibility or fix the version eventually
  spec.add_dependency "activemodel" # TODO: get rid of this dependency (currently used by Event)
  spec.add_dependency "delivery_boy"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
end
