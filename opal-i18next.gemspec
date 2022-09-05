require_relative "opal/i18next/version"

Gem::Specification.new do |spec|
  spec.name = "opal-i18next"
  spec.version = I18next::VERSION
  spec.summary = "An Opal wrapper for the JavaScript i18next module."
  spec.description = <<~DESC
    A basic Opal wrapper for the JavaScript i18next module that supports methods
    addResource, addResourceBundle, addResources, changeLanguage, dir, exists,
    getDataByLanguage, getResource, getResourceBundle, hasResourceBundle, init,
    language, languages, loadNamespaces, off, on, removeResourceBundle,
    resolvedLanguage, store.on, t, and use. It also provides method
    import_js_module for loading i18next plugins.
  DESC
  spec.authors = ["Larry North"]

  spec.license = "MIT"
  spec.email = ["lnorth@swnorth.com"]
  spec.homepage = "https://github.com/LarryNorth/opal-i18next"
  spec.metadata = {
    "bug_tracker_uri"   => "https://github.com/LarryNorth/opal-i18next/issues",
    "documentation_uri" => "https://www.rubydoc.info/gems/opal-i18next",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/LarryNorth/opal-i18next"
  }

  spec.files += Dir["*.gemspec"]
  spec.files += Dir[".yardopts"]
  spec.files += Dir["lib/**/*"]
  spec.files += Dir["opal/**/*"]
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency 'opal', '~> 1.5.0'
end
