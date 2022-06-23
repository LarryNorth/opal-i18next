require "vendor/i18next"
require "opal"
require "native"

  # Uses PromiseV2 if present
  # @see https://opalrb.com/docs/guides/v1.5.1/async PromiseV2
  module I18next

  Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise

  # {I18next} is a basic wrapper around the JavaScript {https://www.i18next.com i18next module}.
  #
  # It wraps i18next methods {https://www.i18next.com/overview/api#init init},
  # {https://www.i18next.com/overview/api#use use},
  # {https://www.i18next.com/overview/api#t t},
  # {https://www.i18next.com/overview/api#changelanguage changeLanguage}, and
  # {https://www.i18next.com/overview/api#language language}.
  # It also provides method {#import_js_module} for loading {https://www.i18next.com/overview/plugins-and-utils i18next plugins}.
  class I18next

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
      `i18next.use(js_module.default)`
    end

    # Initializes {https://www.i18next.com/overview/api#init i18next}
    # @param options [Hash] a hash with keys matching the {https://www.i18next.com/overview/configuration-options i18next options}
    # @return [Promise] a promise that resolves when i18next has been initialized
    def init(options)
      promise = Promise.new
      `
      i18next.init(#{options.to_n})
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
      i18next.changeLanguage(language).then(
          t => {
            promise.$resolve(t)
          });
      `
      promise
    end

    # @return [String] the current {https://www.i18next.com/overview/api#language i18next} language
    def language
      `i18next.language`
    end

    # The {https://www.i18next.com/overview/api#t i18next} translation associated with a key
    # @param [String] key a key that references a translation, single key only
    # @return [String] the translation associated with the key
    def t(key)
      `i18next.t(key)`
    end
  end
end