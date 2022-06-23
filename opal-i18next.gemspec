require_relative "opal/i18next/version"

Gem::Specification.new do |spec|
  spec.name = "opal-i18next"
  spec.version = I18next::VERSION
  spec.authors = ["Larry North"]
  spec.email = ["lnorth@swnorth.com"]
  spec.summary = "An Opal wrapper for the JavaScript i18next module."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.3"

  # Specify which files should be added to the gem when it is released.
  spec.files += Dir["*.gemspec"]
  spec.files += Dir["lib/**/*"]
  spec.files += Dir["opal/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'opal', '~> 1.5.0'
end
