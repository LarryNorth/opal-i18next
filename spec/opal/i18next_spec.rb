require "opal"
require 'promise'
require "opal/rspec/async"
require "js/i18next-21.9.1"
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
    expect(i18next.dir("de']")).to eq("ltr")

    # Hebrew's reading direction is right-to-left
    expect(i18next.dir("he")).to eq("rtl")
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
      expect(i18next.t("unknown_key", "known_key")).to eq("translation")
    end
  end
end
