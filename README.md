# Opal I18next

*A simple wrapper for the JavaScript {https://www.i18next.com/ i18next} module*

This gem supports i18next's basic functionality. The supported methods are:

- [init](https://www.i18next.com/overview/api#init)
- [use](https://www.i18next.com/overview/api#use)
- [t](https://www.i18next.com/overview/api#t)
- [changeLanguage](https://www.i18next.com/overview/api#changelanguage)
- [language](https://www.i18next.com/overview/api#language)

It also provides method `import_js_module` for loading [i18next plugins](https://www.i18next.com/overview/plugins-and-utils).

## Installation

Install opal-i18next from RubyGems:

```
$ gem install opal-i18next
```

Or include it in your Gemfile for Bundler:

```ruby
gem 'opal-i18next'
```

## Running Specs

Get the dependencies:

    $ bundle install


### Browser

You can run the specs in any web browser, by running the `config.ru` rack file:

    $ bundle exec rackup

And then visiting `http://localhost:9292` in any web browser.

### Headless Browser

You can run the specs in a headless browser, by running:

    $ rake

In addition to the results shown in the console output, you will find a
screenshot of the browser output in file `screenshot.png`.

## Usage Example

{include:file:example/app/application.rb}

The example project is in folder `example` of the source code.

## License
{include:file:LICENSE}
