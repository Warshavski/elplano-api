source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

# https://github.com/plataformatec/devise
# Flexible authentication solution for Rails with Warden.
gem 'devise'

# https://github.com/Netflix/fast_jsonapi
# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'

# Use postgresql as the database for Active Record
# https://github.com/ged/ruby-pg
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
# https://github.com/puma/puma
gem 'puma', '~> 3.11'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
# https://github.com/Shopify/bootsnap
gem 'bootsnap', '>= 1.1.0', require: false

# OAuth 2 provider for Ruby on Rails / Grape.
# https://github.com/doorkeeper-gem/doorkeeper
gem 'doorkeeper', '>= 5.0.1'

# Settings is a plugin that makes managing a table of global key, value pairs easy.
# https://github.com/huacnlee/rails-settings-cached
gem 'rails-settings-cached'

# Rack Middleware for handling Cross-Origin Resource Sharing (CORS), which makes cross-origin AJAX possible.
# https://github.com/cyu/rack-cors
gem 'rack-cors', require: 'rack/cors'

# Exception tracking and logging from Ruby to Rollbar https://docs.rollbar.com/docs/ruby
# https://github.com/rollbar/rollbar-gem
gem 'rollbar'

# Cache
gem 'connection_pool'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  gem 'rspec-parameterized', require: false
end

group :development do
  # Help to kill N+1 queries and unused eager loading
  # https://github.com/flyerhzm/bullet
  gem 'bullet'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'pry-rails'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-sqlimit'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
