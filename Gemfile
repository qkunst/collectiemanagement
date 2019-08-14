# frozen_string_literal: true

source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails' , '>= 5.2.3' #, '5.2.0' #, '>= 5.0.0.rc1', '< 5.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
# gem 'webrick'
gem 'markdown-rails', '>= 0.2.1'
gem 'puma' #, '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 5.0.7' #, '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'#, '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '>= 5.0.0' #, '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.3.5'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks' #, '5.1.1' #, '~> 5.x'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder' #, '~> 2.0'
gem 'cancancan'
gem 'bootsnap'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "capybara", ">= 3.26.0"
  gem "byebug", platform: :mri
end

##############################
## MURBs defaults
##############################

##
## BASIC
##

gem 'pg', '~>0.21'
gem 'devise', '>= 4.6.2'
# gem 'omniauth-facebook'
# gem 'omniauth-google-oauth2'
gem 'carrierwave'#, '~> 1.0'
gem 'carrierwave-imageoptimizer'
gem 'mini_magick' # transforming images
gem 'nokogiri', '>= 1.10.4'
gem 'attribute_normalizer' # keeps the database clean
##
## SEARCH
##

gem 'elasticsearch-model', '~> 5'
gem 'elasticsearch-rails', '~> 5'
gem 'rspec-rails', '>= 3.8.2', group: [:development, :test]

##
## DEVELOPMENT
##
group :development do
  gem "letter_opener"
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'highline'
  gem 'web-console' , '>= 3.7.0' #, '~> 2.0'
  gem 'listen' #, '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen' #, '~> 2.0.0'
end

##
## INTERACTIVITY
##

gem 'simple_form', '>= 4.1.0'
gem 'kramdown' # parsing markdown

##
## STYLING
##

gem 'foundation-rails', '~> 6.3.1', '>= 6.3.1.0'

##
## OTHER FREQUENTLY USED
##

gem 'acts-as-taggable-on'
gem 'act_as_time_as_boolean'
gem 'workbook' , '>= 0.8.1' #, git: 'https://github.com/murb/workbook.git'
gem "nested_form"
# gem 'rack-offline', git: 'https://github.com/murb/rack-offline.git'
gem 'paper_trail'#, '~>4.0.0.rc1'
gem 'paper_trail-association_tracking'
gem 'keyword_finder'
gem 'daemons'
gem 'bundler-audit'
# gem 'delayed_job_active_record'
gem 'redis-rails', '>= 5.0.2'
gem 'exception_notification', '>= 4.3.0'
gem 'zipline', '>= 1.1.0'
gem 'activerecord-session_store', '>= 1.1.3'
gem 'rack-headers_filter'
gem "strip_attributes"

gem "sidekiq"
gem "sidekiq-scheduler"
gem "sidekiq-unique-jobs"

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery' #, '~>2.2'
  gem 'rails-assets-chosen'
  gem 'rails-assets-select2'
  gem 'rails-assets-fetch', '2.0.4'
  gem 'rails-assets-morphdom', '~>2.3.0'
  gem 'rails-assets-Stickyfill', '~>1.1'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'bullet'

end
