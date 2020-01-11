require_relative 'lib/nxt_config/version'

Gem::Specification.new do |spec|
  spec.name          = "nxt_config"
  spec.version       = NxtConfig::VERSION
  spec.authors       = ["Nils Sommer"]
  spec.email         = ["mail@nilssommer.de"]

  spec.summary       = "Simple configuration objects, loadable from YAML files"
  spec.description   = "Create namespaced, immutable objects serving configuration properties to your ruby application."
  spec.homepage      = "https://github.com/nxt-insurance/nxt_config"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/nxt-insurance/nxt_config"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
