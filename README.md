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

## Usage

`opal-i18next` can be added to your Opal application sources using a standard require:

```ruby
# app/application.rb
require "opal"
require "promise"
require "i18next"
require "opal-i18next"

I18n = I18next::I18next.new

...
```

> **Note**: This file requires three important dependencies, `promise`, `i18next` and `opal-i18next`, required in that order.
> You need to bring your own `i18next.js` file as the gem does not include one.
> Download a copy and place it into `app/` or whichever directory
> you are compiling assets from.

See the example application in the `examples` folder of the source code.

## License

(The MIT License)

Copyright (C) 2013 by Larry North

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
