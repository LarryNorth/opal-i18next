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
      i18next.use(touppercase_module)
      i18next.init({
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
      i18next.use(fetch_module)
      i18next.init({
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
end
