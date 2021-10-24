# frozen_string_literal: true

require_relative "lib/gaf/version"

Gem::Specification.new do |spec|
  spec.name          = "gaf"
  spec.version       = Gaf::VERSION
  spec.authors       = ["DiHu"]
  spec.email         = ["huynd6793@gmail.com"]

  spec.summary       = "Create githook webhook and management pull request on worksheet"
  spec.homepage      = "https://github.com/Huyliver6793/gaf"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Huyliver6793/gaf"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "google_drive", "~> 3.0.7"
  spec.add_dependency "chatwork", "~> 0.12.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
