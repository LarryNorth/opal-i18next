require_relative "opal/i18next/version"

Gem::Specification.new do |spec|
  spec.name = "opal-i18next"
  spec.version = I18next::VERSION
  spec.authors = ["Larry North"]
  spec.email = ["lnorth@swnorth.com"]
  spec.summary = "An Opal wrapper for the JavaScript i18next module."
  spec.description = <<~DESC
    A basic Opal wrapper for the JavaScript i18next module that supports methods
    init, use, t, changeLanguage, and language. Is also provides method
    import_js_module for loading i18next plugins.
  DESC
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.3"

  spec.files += Dir["*.gemspec"]
  spec.files += Dir["lib/**/*"]
  spec.files += Dir["opal/**/*"]
  spec.require_paths = ["lib"]

  spec.add_dependency 'opal', '~> 1.5.0'
end
