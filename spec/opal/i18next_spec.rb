require "opal"
require 'promise'
require "opal/rspec/async"
require "js/i18next-21.9.1"
require "i18next/i18next"

RSpec.describe I18next do
  context "when there is a Javascript module" do
    it "can import the default export" do
      i18next = I18next::I18next.new
      promise = Promise.new
      i18next.import_js_module("../../js/js_module").then do |js_module|
        promise.resolve(`js_module.default`)
      end.then do |default_export|
        expect(default_export).to eq("default export")
      end
    end
  end

  context "when initialized" do
   it "can change the language" do
    i18next = I18next::I18next.new
    i18next.init({
      fallbackLng: "en",
      resources: {
        en: {
           translation: { key: "hello world" }
        },
        de: {
          translation: { key: "hallo welt" }
        }
      }
    }).then do
      expect(i18next.exists("key")).to be(true)
      expect(i18next.exists("unknown_key")).to be(false)

      expect(i18next.languages).to eq(["en"])
      expect(i18next.language).to eq("en")

      expect(i18next.t("key")).to eq("hello world")

      i18next.change_language("de").then do
        expect(i18next.languages).to eq(["de", "en"])
        expect(i18next.resolved_language).to eq("de")
        expect(i18next.language).to eq("de")
        expect(i18next.t("unknown_key", "key")).to eq("hallo welt")
      end
    end
   end
  end
end
