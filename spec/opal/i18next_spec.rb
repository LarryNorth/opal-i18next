require "opal"
require 'promise'
require "opal/rspec/async"
require "js/i18next-21.9.1-umd"
require "i18next/i18next"

RSpec.describe I18next do
  let(:i18next) { I18next::I18next.new }

  it "can import a JavaScript module's default export" do
    promise = Promise.new
    i18next.import_js_module("../../js/js_module").then do |js_module|
      promise.resolve(`js_module.default`)
    end.then do |default_export|
      expect(default_export).to eq("default export")
    end
  end

  it "can use an i18next plugin" do
    i18next.import_js_module("../../js/i18next-touppercase").then do |touppercase_module|
      i18next.use(touppercase_module).init({
        lng: "en",
        resources: {
          en: {
             translation: { key: "lowercase" }
          }
        }
      }).then do
        expect(i18next.t("key", { postProcess: 'touppercase' })).to eq("LOWERCASE")
      end
    end
  end

  it "can test a key's existence" do
    i18next.init({
      lng: "en",
      resources: {
        en: {
           translation: { known_key: "known" }
        }
      }
    }).then do
      expect(i18next.exists("known_key")).to be(true)
      expect(i18next.exists("unknown_key")).to be(false)
    end
  end

  it "can determine a language's reading direction" do
      i18next.init({}).then do
      expect(i18next.dir("de']")).to eq("ltr")

      # Hebrew's reading direction is right-to-left
      expect(i18next.dir("he")).to eq("rtl")
    end
  end

  it "can determine the current language's reading direction" do
    i18next.init({
      lng: "en",
    }).then do
      expect(i18next.dir).to be("ltr")
    end
  end

  it "can determine the current language" do
    i18next.init({
      lng: "en",
    }).then do
      expect(i18next.language).to be("en")
    end
  end

  it "can change the language" do
    i18next.init({
      lng: "en",
    }).then do
      i18next.change_language("de").then do
        expect(i18next.language).to eq("de")
      end
    end
  end

  it "can find the languages that will used for translations" do
    i18next.init({
      fallbackLng: "en",
    }).then do
      expect(i18next.languages).to eq(["en"])
      i18next.change_language("de").then do
        expect(i18next.languages).to eq(["de", "en"])
      end
    end
  end

  it "can do a translation" do
    i18next.init({
      fallbackLng: "en",
      resources: {
        en: {
           translation: { known_key: "translation" }
        }
      }
   }).then do
      expect(i18next.t("known_key")).to eq("translation")
      expect(i18next.t(["unknown_key", "known_key"])).to eq("translation")
    end
  end

  it "can load namespaces" do
    i18next.import_js_module("../../js/i18next-fetch-backend-3.0.0.ems.js").then do |fetch_module|
      i18next.use(fetch_module).init({
        debug: true,
        ns: "default",
        fallbackLng: "en",
        backend: { loadPath: '/spec/locales/{{lng}}/{{ns}}.json' }
      }).then do
        expect(i18next.t("key")).to eq("en default")
        expect(i18next.exists("other_key", { ns: "other" })).to be false
        i18next.load_namespaces("other"). then do
          expect(i18next.t("other_key", { ns: "other" })).to eq("en other")
        end
      end
    end
  end

  it "can add a resource" do
    i18next.init({
      debug: true
    }).then do
      i18next.add_resource("fr", "default", "key", "Français")
      expect(i18next.t("key", { lng: "fr", ns: "default" })).to eq("Français")
    end
  end

  it "can get a resource" do
    i18next.init({
      debug: true
    }).then do
      i18next.add_resource("fr", "default", "key", "Français")
      expect(i18next.get_resource("fr", "default", "key", "Français")).to eq("Français")
    end
  end

  it "can add resources" do
    i18next.init({
      debug: true,
      lng: "fr",
      ns: "default"
    }).then do
      i18next.add_resources("fr", "default", {
        french: "Français",
        german: "Allemand"
      })
      expect(i18next.t("french")).to eq("Français")
      expect(i18next.t("german")).to eq("Allemand")
    end
  end

  it "can get a resource bundle" do
    i18next.init({
      debug: true,
      resources: {
        en: {
          default: {
            key: "value"
          }
        }
      }
    }).then do
      expect(i18next.get_resource_bundle("en", "default")).to eq({ key: "value" })
    end
  end

  it "can add a resource bundle" do
    i18next.init({
      debug: true
    }).then do
      i18next.add_resource_bundle("fr", "default", { french: "Français", spanish: "Espagnol" })
      expect(i18next.get_resource_bundle("fr", "default")).to eq({ french: "Français", spanish: "Espagnol" })
    end
  end

  it "can extend a resource bundle" do
    i18next.init({
      debug: true
    }).then do
      i18next.add_resource_bundle("fr", "default", { french: "Français", spanish: "Espagnol" })
      expect(i18next.get_resource_bundle("fr", "default")).to eq({ french: "Français", spanish: "Espagnol" })
      i18next.add_resource_bundle("fr", "default", { german: "Allemand" }, true)
      expect(i18next.get_resource_bundle("fr", "default")).to eq({ french: "Français", spanish: "Espagnol", german: "Allemand" })
    end
  end

  it "can check if a resource bundle exists" do
    i18next.init({
      debug: true
    }).then do
      expect(i18next.has_resource_bundle("fr", "default")).to be false
      i18next.add_resource_bundle("fr", "default", { french: "Français", spanish: "Espagnol" })
      expect(i18next.has_resource_bundle("fr", "default")).to be true
    end
  end

  it "can remove a resource bundle" do
    i18next.init({
      debug: true
    }).then do
      i18next.add_resource_bundle("fr", "default", { french: "Français", spanish: "Espagnol" })
      expect(i18next.has_resource_bundle("fr", "default")).to be true
      i18next.remove_resource_bundle("fr", "default")
      expect(i18next.has_resource_bundle("fr", "default")).to be false
    end
  end

  it "can set the default namespace" do
    i18next.init({
      debug: true,
      lng: "en",
      ns: "default",
      resources: {
        en: {
          default: {
            "key": "default"
          },
          other: {
            "key": "other"
          }
        }
      }
    }).then do
      expect(i18next.t("key")).to eq("default")
      i18next.set_default_namespace("other")
      expect(i18next.t("key")).to eq("other")
    end
  end

  def oh(options)
    JSON.parse(`JSON.stringify(options)`)
  end

  it "can handle the initialized event" do
    initializedOptions = nil
    i18next.on("initialized") { |options| initializedOptions  = options }
    options = {
      debug: true,
      lng: "en",
      ns: ["default"],
      resources: {
        en: {
          default: {
            "key": "default"
          },
          other: {
            "key": "other"
          }
        }
      }
    }
    i18next.init(options).then do
      # Ignore the default options values, which are also included in the
      # options passed to the initialized event listener.
      expect(initializedOptions).to include(options)
    end
  end

  it "can handle a language changed event" do
    newLanguage = nil
    i18next.on('languageChanged') { |lng|
      newLanguage = lng
    }
    i18next.init({
      lng: "en"
    }).then do
      expect(i18next.language).to eq("en")
      i18next.change_language("de").then do
        expect(newLanguage).to eq("de")
      end
    end
  end

  it "can handle an added store event" do
    added_lng = nil
    added_ns = nil
    i18next.init({}).then do
      i18next.store_on('added') { |lng, ns|
        added_lng = lng
        added_ns = ns
      }
      i18next.add_resource("fr", "default", "key", "Français")
      expect(added_lng).to eq("fr")
      expect(added_ns).to eq("default")
    end
  end

  it "can handle a removed store event" do
    removed_lng = nil
    removed_ns = nil
    i18next.init({
      lng: "en",
      ns: "default",
      resources: {
        en: {
           default: { known_key: "known" }
        }
      }
    }).then do
      expect(i18next.exists("known_key")).to be(true)
      i18next.store_on('removed') { |lng, ns|
        removed_lng = lng
        removed_ns = ns
      }
      i18next.remove_resource_bundle("en", "default")
      expect(removed_lng).to eq("en")
      expect(removed_ns).to eq("default")
    end
  end

  it "can unsubscribe an event's listeners" do
    newLanguage = nil
    i18next.on('languageChanged') { |lng|
      newLanguage = lng
    }
    i18next.init({
      lng: "en"
    }).then do
      expect(i18next.language).to eq("en")
      i18next.off('languageChanged')
      newLanguage = nil
      i18next.change_language("de").then do
        expect(newLanguage).to be_nil
      end
    end
  end

  it "can unsubscribe an event listener" do
    event_1_triggered = false
    event_2_triggered = false
    i18next.on('languageChanged') { |lng|
      event_1_triggered = true
    }
    listener_2 = i18next.on('languageChanged') { |lng|
      event_2_triggered = true
    }
    i18next.init({
      lng: "en"
    }).then do
      i18next.change_language("de").then do
        expect(event_1_triggered).to be true
        expect(event_2_triggered).to be true
        i18next.off('languageChanged', listener_2)
        event_1_triggered = false
        event_2_triggered = false
        i18next.change_language("fr").then do
          expect(event_1_triggered).to be true
          expect(event_2_triggered).to be false
        end
      end
    end
  end

  it "can handle a loaded event" do
    i18next.import_js_module("../../js/i18next-fetch-backend-3.0.0.ems.js").then do |fetch_module|
      lng_ns = nil
      i18next.use(fetch_module).on('loaded') { |loaded|
        lng_ns = loaded
      }
      i18next.init({
        debug: true,
        fallbackLng: "en",
        ns: "default",
        backend: { loadPath: '/spec/locales/{{lng}}/{{ns}}.json' }
      }).then do
        expect(lng_ns).to eq({ en: { default: true } })
        i18next.load_namespaces("other"). then do
          expect(lng_ns).to eq({ en: { other: true } })
        end
      end
    end
  end

  it "can handle a failedLoading event" do
    i18next.import_js_module("../../js/i18next-fetch-backend-3.0.0.ems.js").then do |fetch_module|
      failed_lng = nil
      failed_ns = nil
      failed_msg= nil
      i18next.use(fetch_module).on('failedLoading') { |lng, ns, msg|
        failed_lng = lng
        failed_ns = ns
        failed_msg= msg
      }
      i18next.init({
        debug: true,
        fallbackLng: "en",
        ns: "default",
        backend: { loadPath: '/spec/locales/{{lng}}/{{ns}}.json' }
      }).then do
        i18next.load_namespaces("unknown"). then do
          expect(failed_lng).to eq("en")
          expect(failed_ns).to eq("unknown")
          expect(failed_msg.start_with?("failed loading")).to be true
        end
      end
    end
  end

  it "can handle a missingKey event" do
    i18next.import_js_module("../../js/i18next-fetch-backend-3.0.0.ems.js").then do |fetch_module|
      missing_lng = nil
      missing_ns = nil
      missing_key = nil
      missing_res = nil
      i18next.use(fetch_module).on('missingKey') { |lng, ns, key, res|
        missing_lng = lng
        missing_ns = ns
        missing_key = key
        missing_res = res
      }
      i18next.init({
        debug: true,
        fallbackLng: "sp",
        saveMissing: true,
        ns: "default",
        backend: { loadPath: '/spec/locales/{{lng}}/{{ns}}.json' }
      }).then do
        i18next.t("unknown_key"). then do
          expect(missing_lng).to eq(["sp"])
          expect(missing_ns).to eq("default")
          expect(missing_key).to eq("unknown_key")
          expect(missing_res).to eq("unknown_key")
        end
      end
    end
  end
end
