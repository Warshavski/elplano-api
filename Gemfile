source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# The official AWS SDK for Ruby
# https://github.com/aws/aws-sdk-ruby/tree/master/gems/aws-sdk-s3
gem 'aws-sdk-s3'

# https://github.com/plataformatec/devise
# Flexible authentication solution for Rails with Warden.
gem 'devise', '>= 4.7.1'

# https://github.com/dry-rb/dry-validation
# Validation library with type-safe schemas and rules https://dry-rb.org/gems/dry-validation
gem 'dry-validation', '>=1.3.0'

# https://github.com/Netflix/fast_jsonapi
# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi', '>= 1.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'

# Use postgresql as the database for Active Record
# https://github.com/ged/ruby-pg
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
# https://github.com/puma/puma
gem 'puma', '>= 4.3.3'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Authorization framework for Ruby/Rails applications
# https://github.com/palkan/action_policy
gem 'action_policy'

# Reduces boot times through caching; required in config/boot.rb
# https://github.com/Shopify/bootsnap
gem 'bootsnap', '>= 1.1.0', require: false

# User agent parsing
# https://github.com/podigee/device_detector
gem 'device_detector'

# OAuth 2 provider for Ruby on Rails / Grape.
# https://github.com/doorkeeper-gem/doorkeeper
gem 'doorkeeper', '~> 5.2.1'

# Fishes out the Accept-Language header into an array.
# https://github.com/iain/http_accept_language
gem 'http_accept_language', '~> 2.1'

# A Ruby wrapper for the OAuth 2.0 specification.
# https://github.com/oauth-xx/oauth2
gem 'oauth2'

# The Official SendGrid Led, Community Driven Ruby API Library
# https://github.com/sendgrid/sendgrid-ruby
gem 'sendgrid-ruby'

# Simple, efficient background processing for Ruby
# https://github.com/mperham/sidekiq
gem 'sidekiq'

# Lightweight job scheduler extension for Sidekiq
# https://github.com/moove-it/sidekiq-scheduler
gem 'sidekiq-scheduler'

# File Attachment toolkit for Ruby applications.
# https://github.com/shrinerb/shrine
gem 'shrine', '~> 2.0'

# A Scope & Engine based, clean, powerful, customizable and sophisticated paginator
# https://github.com/kaminari/kaminari
gem 'kaminari'

# Settings is a plugin that makes managing a table of global key, value pairs easy.
# https://github.com/huacnlee/rails-settings-cached
gem 'rails-settings-cached', '~> 0.7.2'

# Rack middleware for blocking & throttling
# https://github.com/kickstarter/rack-attack
gem 'rack-attack'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.
# https://github.com/cyu/rack-cors
gem 'rack-cors', '>= 1.0.6', require: 'rack/cors'

# Exception tracking and logging from Ruby to Rollbar https://docs.rollbar.com/docs/ruby
# https://github.com/rollbar/rollbar-gem
gem 'rollbar'

# Per-request global storage for Rack.
# https://github.com/steveklabnik/request_store
gem 'request_store'

# Cache
gem 'connection_pool'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'

# System information
#
# A focused and fast library to gather memory, cpu, network, load avg and disk information
# https://github.com/threez/ruby-vmstat
gem 'vmstat'

#
# A Ruby library for getting filesystem information
# https://github.com/djberg96/sys-filesystem
gem 'sys-filesystem'

# Automatically generate API documentation from RSpec
# https://github.com/zipmark/rspec_api_documentation
gem 'rspec_api_documentation'

# Apitome: /iˈpitəmē/ An API documentation reader for RSpec API Documentation.
# https://github.com/jejacks0n/apitome
gem 'apitome'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Help to kill N+1 queries and unused eager loading
  # https://github.com/flyerhzm/bullet
  gem 'bullet'

  gem 'rspec-rails'
  gem 'rspec-parameterized', require: false

  # Shim to load environment variables from .env into ENV in development.
  # https://github.com/bkeepers/dotenv
  gem 'dotenv-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-sqlimit'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers', '>= 4.0.0'
  gem 'shrine-memory'
  gem 'simplecov'
  gem 'webmock'
  gem 'timecop'

  # Ruby Tests Profiling Toolbox
  # https://github.com/palkan/test-prof
  gem 'test-prof'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
