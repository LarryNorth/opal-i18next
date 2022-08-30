require "opal"
require "native"

  # Uses PromiseV2 if present
  # @see https://opalrb.com/docs/guides/v1.5.1/async PromiseV2
  module I18next

  Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise

  # {I18next} is a basic wrapper around the JavaScript {https://www.i18next.com i18next module}.
  #
  # It wraps i18next methods {https://www.i18next.com/overview/api#addResource addResource},
  # {https://www.i18next.com/overview/api#changelanguage changeLanguage},
  # {https://www.i18next.com/overview/api#dir dir},
  # {https://www.i18next.com/overview/api#exists exists},
  # {https://www.i18next.com/overview/api#getResource getResource},
  # {https://www.i18next.com/overview/api#init init},
  # {https://www.i18next.com/overview/api#language language},
  # {https://www.i18next.com/overview/api#languages languages},
  # {https://www.i18next.com/overview/api#loadNamespaces loadNamespaces},
  # {https://www.i18next.com/overview/api#resolvedLanguage resolvedLanguage},
  # {https://www.i18next.com/overview/api#setDefaultNamespace setDefaultNamespace},
  # {https://www.i18next.com/overview/api#t t}, and
  # {https://www.i18next.com/overview/api#use use}.
  # It also provides method {#import_js_module} for loading {https://www.i18next.com/overview/plugins-and-utils i18next plugins}.
  class I18next

    # Each I18next instance has its own i18next Javascript module
    def initialize
      @i18next = `i18next.createInstance()`
    end

    # Imports a JavaScript module (ESM)
    #
    # Use this method to import {https://www.i18next.com/overview/plugins-and-utils i18next JavaScript plugins}
    # that can be passed to the {#use} method.
    #
    # @param module_path [String] the path to the module's *.js file, may be a
    #   file path or a URL
    #
    # @return [Promise] a promise that resolves to the JavaScript module that can be passed
    #  to the {#use} method
    #
    def import_js_module(module_path)
      promise = Promise.new
      `
      import(module_path).then(
        module => {
          promise.$resolve(module);
        });
        `
      promise
    end

    # Loads an {https://www.i18next.com/overview/api#use i18next} plugin
    #
    # @param js_module a plugin's JavaScript module that was imported
    #   by method {#import_js_module}
    def use(js_module)
      `#{@i18next}.use(js_module.default)`
    end

    # Initializes {https://www.i18next.com/overview/api#init i18next}
    # @param options [Hash] a hash with keys matching the {https://www.i18next.com/overview/configuration-options i18next options}.
    # @return [Promise] a promise that resolves when i18next has been initialized
    def init(options = {})
      promise = Promise.new
      `
      #{@i18next}.init(#{options.to_n})
        .then(
          t => {
            promise.$resolve(t);
          });
      `
      promise
    end

    # Changes the {https://www.i18next.com/overview/api#changelanguage i18next} language
    # @param language [String] the new language
    # @return [Promise] a promise that resolves when the language's
    #   translations have been loaded
    def change_language(language)
      promise = Promise.new
      `
      #{@i18next}.changeLanguage(language).then(
          () => {
            promise.$resolve()
          });
      `
      promise
    end

    # @return [String] the current {https://www.i18next.com/overview/api#language i18next} language
    def language
      `#{@i18next}.language`
    end

    # The {https://www.i18next.com/overview/api#t i18next} translation associated with a key
    # @param [String, Array<String>] key one or more keys that reference translations
    # @param [Hash] options options for formatters, post processors, etc.
    # @return [String] the translation associated with the first key that resolves
    def t(key, options={})
      `#{@i18next}.t(key, #{options.to_n})`
    end

    # @return [Boolean] true if the key exists
    def exists(key)
      `#{@i18next}.exists(key)`
    end

    # @private
    def get_fixed_t
      raise 'Not implemented'
    end

    # @see https://www.i18next.com/overview/api#languages The i18next languages method
    # @return language codes that will be used to look up the translation value
    def languages
      `#{@i18next}.languages`
    end

    # @see https://www.i18next.com/overview/api#resolvedLanguage The i18next resolvedLanguage method
    # @return the current resolved language
    def resolved_language
      `#{@i18next}.resolvedLanguage`
    end

    # Loads additional namespaces not defined in init options
    # @param [String, Array<String>] ns one or more namespaces
    # @return [Promise] a promise that resolves when the namespaces have been loaded
    # @see https://www.i18next.com/overview/api#loadNamespaces The i18next loadNamespaces method
    def load_namespaces(ns)
      promise = Promise.new
      `
      #{@i18next}.loadNamespaces(ns)
        .then(
          () => {
            promise.$resolve()
          });
      `
      promise
    end

    # @private
    def load_languages(*lngs)
      raise 'Not implemented'
    end

    # @private
    def reload_resources
      raise 'Not implemented'
    end

    # Changes the default namespace.
    # @param ns [String] new default namespace
    # @see https://www.i18next.com/overview/api#setDefaultNamespace The i18next setDefaultNamespace method
    def set_default_namespace(ns)
      `#{@i18next}.setDefaultNamespace(ns)`
    end

    # Get a language's reading direction
    # @param lng [String] the language; if omitted, the current language is used
    # @return "ltr" or "rtl"
    # @see https://www.i18next.com/overview/api#dir The i18next dir method
    def dir(lng)
      `#{@i18next}.dir(lng)`
    end

    # @private
    def format(data, format, lng)
      raise 'Not implemented'
    end

    # @private
    def create_instance(options)
      raise 'Not implemented'
    end

    # @private
    def clone_instance(options)
      raise 'Not implemented'
    end

    # @private
    def off
      raise 'Not implemented'
    end

    # @private
    def on
      raise 'Not implemented'
    end

    # Gets one value by given key.
    # @see https://www.i18next.com/overview/api#getResource The i18next getResource method
    def get_resource(lng, ns, key, options = {})
      `#{@i18next}.getResource(lng, ns, key, options)`
    end

    # Adds one key/value.
    # @see https://www.i18next.com/overview/api#addResource The i18next addResource method
    def add_resource(lng, ns, key, value, options = {})
      `#{@i18next}.addResource(lng, ns, key, value, options)`
    end

    # @private
    def add_resources(lng, ns, resources)
      raise 'Not implemented'
    end

    # @private
    def add_resource_bundle(lng, ns, resouces, deep, overwrite)
      raise 'Not implemented'
    end

    # @private
    def has_resource_bundle(lng, ns)
      raise 'Not implemented'
    end

    # @private
    def get_data_by_language(lng)
      raise 'Not implemented'
    end

    # @private
    def get_resource_bundle(lng, ns)
      raise 'Not implemented'
    end

    # @private
    def remove_resource_bundle(lng, ns)
      raise 'Not implemented'
    end

  end
end
