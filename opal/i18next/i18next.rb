require "opal"
require "native"
require "json"

# Uses PromiseV2 if present
# @see https://opalrb.com/docs/guides/v1.5.1/async PromiseV2
module I18next

  Promise = defined?(PromiseV2) ? PromiseV2 : ::Promise

  # {I18next} is a basic wrapper around the JavaScript {https://www.i18next.com i18next module}.
  #
  # It wraps i18next methods {https://www.i18next.com/overview/api#addResource addResource},
  # {https://www.i18next.com/overview/api#addResourceBundle addResourceBundle},
  # {https://www.i18next.com/overview/api#addResources addResources},
  # {https://www.i18next.com/overview/api#changelanguage changeLanguage},
  # {https://www.i18next.com/overview/api#dir dir},
  # {https://www.i18next.com/overview/api#exists exists},
  # {https://www.i18next.com/overview/api#getDataByLanguage getDataByLanguage},
  # {https://www.i18next.com/overview/api#getFixedT getFixedT},
  # {https://www.i18next.com/overview/api#getResource getResource},
  # {https://www.i18next.com/overview/api#getResourceBundle getResourceBundle},
  # {https://www.i18next.com/overview/api#hasResourceBundle hasResourceBundle},
  # {https://www.i18next.com/overview/api#init init},
  # {https://www.i18next.com/overview/api#language language},
  # {https://www.i18next.com/overview/api#languages languages},
  # {https://www.i18next.com/overview/api#loadLanguages loadLanguages},
  # {https://www.i18next.com/overview/api#loadNamespaces loadNamespaces},
  # {https://www.i18next.com/overview/api#events off},
  # {https://www.i18next.com/overview/api#events on},
  # {https://www.i18next.com/overview/api#removeResourceBundle removeResourceBundle},
  # {https://www.i18next.com/overview/api#resolvedLanguage resolvedLanguage},
  # {https://www.i18next.com/overview/api#setDefaultNamespace setDefaultNamespace},
  # {https://www.i18next.com/overview/api#https://www.i18next.com/overview/api#store-events store.on},
  # {https://www.i18next.com/overview/api#t t}, and
  # {https://www.i18next.com/overview/api#use use}.
  #
  # It can handle {https://www.i18next.com/overview/api#events i18next events}. See methods on
  # and off.
  #
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
    # @return [I18next::I18next] self
    def use(js_module)
      `#{@i18next}.use(js_module.default)`
      self
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

    # Returns a Proc that acts a +t+ method that defaults to a language and namespace.
    # @example When calling the returned Proc, use brackets, not parentheses
    #   en = get_fixed_t("en")
    #   translation = en["key"]
    # @param lng [String] language
    # @param ns [String] namespace
    # @param key_prefix [String] key prefix
    # @see https://www.i18next.com/overview/api#getFixedT The i18next getFixedT method
    def get_fixed_t(lng = nil, ns = nil, key_prefix = nil)
      if key_prefix && ns && lng
        `#{@i18next}.getFixedT(lng, ns, key_prefix)`
      elsif ns && lng
        `#{@i18next}.getFixedT(lng, ns)`
      elsif lng
        `#{@i18next}.getFixedT(lng)`
      else
        `#{@i18next}.getFixedT()`
      end
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
    # @param ns [String, Array<String>] one or more namespaces
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

    # Loads additional languages not defined in init options (preload).
    # @param lngs [String, Array<String>] one or more languages
    # @return [Promise] a promise that resolves when the languages have been loaded
    # @see https://www.i18next.com/overview/api#loadLanguages The i18next loadLanguages method
    def load_languages(lngs)
      promise = Promise.new
      `
      #{@i18next}.loadLanguages(lngs)
      .then(
        () => {
          promise.$resolve()
        });
    `
      promise
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

    # Adds multiple key/values.
    # @param resources [Hash] key/value pairs
    # @see https://www.i18next.com/overview/api#addResources The i18next addResources method
    def add_resources(lng, ns, resources)
      `#{@i18next}.addResources(lng, ns, #{resources.to_n})`
    end

    # Adds a complete bundle
    # @param lng [String] bundle language
    # @param ns [String] bundel namespace
    # @param deep [Boolean] if true will extend existing translations in the bundle
    # @param overwrite [Boolean] if true it will overwrite existing translations in the bundle
    # @see https://www.i18next.com/overview/api#addResourceBundle The i18next addResourceBundle method
    def add_resource_bundle(lng, ns, resources, deep = false, overwrite = false)
      `#{@i18next}.addResources(lng, ns, #{resources.to_n}, deep, overwrite)`
    end

    # Checks if a resource bundle exists
    # @param lng [String] language
    # @param ns [String] namespace
    def has_resource_bundle(lng, ns)
      `#{@i18next}.hasResourceBundle(lng, ns)`
    end

    # Returns resource data for a language.
    # @param lng [String] language
    # @return resource data
    # @see https://www.i18next.com/overview/api#getDataByLanguage The i18next getDataByLanguage method
    def get_data_by_language(lng)
      js_obj_to_ruby_hash(`#{@i18next}.getDataByLanguage(lng)`)
    end

    # Gets a resource bundle.
    # @return [Hash] key/value pairs
    # @see https://www.i18next.com/overview/api#getResourceBundle The i18next getResourceBundle method
    def get_resource_bundle(lng, ns)
      js_obj_to_ruby_hash(`#{@i18next}.getResourceBundle(lng, ns)`)
    end

    # Removes a resource bundle exists
    # @param lng [String] language
    # @param ns [String] namespace
    def remove_resource_bundle(lng, ns)
      `#{@i18next}.removeResourceBundle(lng, ns)`
    end

    # Create a listener for an i18next event.
    # @param event [String] event name
    # @param &listener [block] an event listener that is passed event-dependent arguments
    # @return [Proc] the listener, which can be used to unsubscribe it via method off(event, listener)
    # @see https://www.i18next.com/overview/api#events The i18next events
    # @see #off
    def on(event, &listener)
      # Some events require special listeners because those events return JavaScript objects
      # to the listeners, and those object must be converted to Ruby Hashes.
      case event
      when "initialized"
        _onInitialized(listener)
      when "loaded"
        _onLoaded(listener)
      else
        `#{@i18next}.on(event, listener)`
      end
      listener
    end

    # Create a listener for an i18next store event.
    #
    # Only available after the init call.
    #
    # @param event [String] event name ("added" or "removed")
    # @param &listener [block] an event listener that is passed language and namespace arguments
    # @return [Proc] the listener, which can be used to unsubscribe it via method off(event, listener)
    # @see https://www.i18next.com/overview/api#store-events The i18next store events
    def store_on(event, &listener)
      `#{@i18next}.store.on(event, listener)`
      listener
    end

    # Unsubscribes an event's listener(s)
    # @param event [String] event name
    # @param listener [Proc] the listener to unsubscribe; if absent, unsubscribe all listeners
    def off(event, listener = nil)
      if listener
        `#{@i18next}.off(event, listener)`
      else
        `#{@i18next}.off(event)`
      end
    end

    private

    # @private
    # Create a listener for the i18next initialized event.
    # @param &listener [Proc] an event listener block that is passed initialized options Hash
    # @see https://www.i18next.com/overview/api#oninitialized The i18next initialized event
    def _onInitialized(listener)
      `
      #{@i18next}.on("initialized", (options) => {
        // Convert the JavaScript options object to a string and
        // then convert that string to a Ruby hash that is passed
        // to the listener.
        listener.$call(Opal.JSON.$parse(JSON.stringify(options)))
      })
      `
    end

    # @private
    # Create a listener for the i18next loaded event.
    # @param listener [Proc] an event listener block that is passed loaded Hash
    # @see https://www.i18next.com/overview/api#onloaded The i18next onLoaded event
    def _onLoaded(listener)
      `
      #{@i18next}.on("loaded", (loaded) => {
        // Convert the JavaScript load object to a string and
        // then convert that string to a Ruby hash that is passed
        // to the listener.
        listener.$call(Opal.JSON.$parse(JSON.stringify(loaded)))
      })
      `
    end

    # @private
    # Convert a JavaScript obj to a Ruby Hash.
    # @param js_obj JavaScript object
    # @return [Hash] Ruby Hash
    def js_obj_to_ruby_hash(js_obj)
      # Convert the JavaScript object to a string and then convert that string
      # to a Ruby hash.
      JSON.parse(`JSON.stringify(js_obj)`)
    end
  end
end
