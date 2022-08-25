# A simple application that uses the opal-browser and opal-i18next gems.
# It displays a greeting and has a button that toggles the greeeting's
# and button's language.

require "opal"
require "promise"
require "browser/setup/traditional"
require "i18next-21.9.1"
require "opal-i18next"

I18n = I18next::I18next.new

# Import the i18next fetch backend JavaScript module, which can load resources
# from a backend server. Here it is used to load the translations.
I18n.import_js_module('https://unpkg.com/i18next-fetch-backend@3.0.0/dist/i18next-fetch-backend.esm.js').then do |js_module|

  # After the fetch module is loaded, initialize i18next.
  I18n.use(js_module)
  I18n.init({
    debug: true,
    fallbackLng: "en",
    backend: { loadPath: '/locales/{{lng}}/{{ns}}.json' }
  }).then do

    # After i18next is initialized, initialize the app.
    $document.ready { init }
  end
end

def init
  html = Paggio.html! do
    div.greeting!
    div do
      button.change_language_button!
    end
  end
  $document.at_css("#container").inner_html = html
  $document.at_css("#change_language_button").on(:click) do |e|
    e.prevent
    change_language
  end
  update
end

def update
  $document.at_css("#greeting").text = I18n.t("greeting")
  $document.at_css("#change_language_button").text = I18n.t("button_label")
end

def change_language
  if I18n.language == "en"
    language = "de"
  else
    language = "en"
  end

  # Disable the language button during the asynchronous change language.
  $document.at_css("#change_language_button").disabled = true

  I18n.change_language(language).then do
    update
    $document.at_css("#change_language_button").disabled = false
  end
end
