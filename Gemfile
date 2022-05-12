# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~>6"
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
# gem 'webrick'
# gem "markdown-rails"
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier"
# Use CoffeeScript for .coffee assets and views
# gem "coffee-rails" # , '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem "therubyracer", platforms: :ruby

# Use jquery as the JavaScript library
# gem "jquery-rails"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
gem "cancancan"
gem "bootsnap"
gem "lockbox"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "capybara"
  gem "byebug", platform: :mri
  gem "foreman"
end

##############################
## MURBs defaults
##############################

##
## BASIC
##
gem "bundler-audit"
gem "pg"
gem "devise" #, git: "https://github.com/heartcombo/devise.git"
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
gem "rspec-rails", group: [:development, :test]

##
## DEVELOPMENT
##
group :development do
  gem "letter_opener"
  gem "capistrano"
  gem "capistrano-rbenv"
  gem "capistrano-bundler"
  gem "capistrano-rails"
  gem 'capistrano-sidekiq' #, group: :development
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
gem "paper_trail", "11.1.0"
gem "paper_trail-association_tracking"
gem "keyword_finder"
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
gem "webpacker"

gem "rack-mini-profiler"
gem "flamegraph"
gem "stackprof"
gem "memory_profiler"

group :test, :gitlab do
  gem "database_cleaner"
  gem "simplecov", require: false
  gem "bullet"
end
gem "standard", group: [:development, :test]
gem "dotenv-rails", groups: [:development, :test]
gem "annotate", group: [:development]

gem "branding_repo"
gem "omniauth-central_login", git: "https://gitlab.com/murb-org/omniauth-centrallogin.git"