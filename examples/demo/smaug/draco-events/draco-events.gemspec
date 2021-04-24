require_relative 'lib/draco/events'

Gem::Specification.new do |spec|
  spec.name          = "draco-events"
  spec.version       = Draco::Events::VERSION
  spec.authors       = ["Matt Pruitt"]
  spec.email         = ["matt@guitsaru.com"]

  spec.summary       = %q{An event bus for the Draco ECS library.}
  spec.description   = %q{An event bus for the Draco ECS library.}
  spec.homepage      = "https://github.com/guitsaru/draco-events"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/guitsaru/draco-events"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
