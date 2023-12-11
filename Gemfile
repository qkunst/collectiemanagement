# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~>7"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
# gem 'webrick'
# gem "markdown-rails"
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails"
# Use Uglifier as compressor for JavaScript assets
# gem "uglifier"
# Use CoffeeScript for .coffee assets and views
# gem "coffee-rails" # , '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

# Use jquery as the JavaScript library
# gem "jquery-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
gem "cancancan"
gem "bootsnap"
gem "lockbox"
group :development, :test, :gitlabci do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "capybara"
  gem "byebug", platform: :mri
  gem "foreman"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "simplecov-cobertura"
end

##############################
## MURBs defaults
##############################

##
## BASIC
##
gem "bundler-audit"
gem "pg"
gem "devise" # , git: "https://github.com/heartcombo/devise.git"
# gem 'omniauth-facebook'
# gem 'omniauth-google-oauth2'
gem "carrierwave"
gem "carrierwave-imageoptimizer"
gem "mini_magick" # transforming images
gem "nokogiri"
gem "attribute_normalizer" # keeps the database clean
##
## SEARCH
##

gem "elasticsearch-model", "~> 7"
gem "elasticsearch-rails", "~> 7"

##
## DEVELOPMENT
##
group :development do
  gem "letter_opener"
  gem "capistrano"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem "capistrano-sidekiq" # , group: :development
  gem "highline"
  gem "web-console"
  gem "listen"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen' #, '~> 2.0.0'
end

##
## INTERACTIVITY
##

gem "simple_form"
gem "kramdown"

##
## STYLING
##

gem "foundation-rails"
gem "autoprefixer-rails"

##
## OTHER FREQUENTLY USED
##

gem "acts-as-taggable-on"
gem "act_as_time_as_boolean"
gem "workbook", git: "https://github.com/murb/workbook.git", branch: :main
gem "nested_form"
gem "paper_trail" # , "11.1.0"
gem "paper_trail-association_tracking"
gem "keyword_finder"
gem "mail", "~> 2.7.0"
gem "daemons"
gem "redis-rails" # jobs
gem "dalli" # memcache
gem "exception_notification"
gem "zipline"
gem "rack-headers_filter"
gem "strip_attributes"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "omniauth-azure-activedirectory", git: "https://github.com/murb/omniauth-azure-activedirectory.git"
gem "sidekiq", "~> 6", ">= 6.2.1"
gem "sidekiq-scheduler", ">= 3.1.0"
gem "sidekiq-unique-jobs", ">= 7.1.5"
# gem "webpacker"

gem "rack-mini-profiler"
gem "flamegraph"
gem "stackprof"
gem "memory_profiler"

group :test, :gitlabci do
  gem "database_cleaner"
  gem "simplecov", require: false
  gem "bullet"
  gem "rspec-openapi", ">= 0.10.0"
end
gem "standard", group: [:development, :test]
gem "dotenv-rails", groups: [:development, :test]
gem "annotate", group: [:development]

gem "branding_repo", git: "https://github.com/murb/branding_repo.git"
gem "omniauth-central_login", git: "https://gitlab.com/murb-org/omniauth-centrallogin.git"
gem "invisible_captcha"
gem "jsbundling-rails", "~> 1.0"
gem "pupprb", git: "https://gitlab.com/murb/pupprb.git"
gem "stimulus-rails"
