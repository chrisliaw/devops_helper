require_relative 'lib/devops_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "devops_helper"
  spec.version       = DevopsHelper::VERSION
  spec.authors       = ["Chris"]
  spec.email         = ["chrisliaw@antrapol.com"]

  spec.summary       = %q{DevOps Helper to assist in DevOps operation}
  spec.description   = %q{ }
  spec.homepage      = "https://github.com/chrisliaw/devops_helper"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'toolrack', '~> 0.4.0'
  spec.add_dependency 'tlogger', '~> 0.22.0'
  spec.add_dependency 'tty-prompt'

  spec.add_dependency 'gvcs', '~> 0.1.0'
  spec.add_dependency 'git_cli', '~> 0.6.0'

  #spec.add_dependency 'rubygems-tasks'

end
