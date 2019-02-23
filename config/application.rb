# frozen_string_literal: true

require_relative 'boot'

require 'rails'

# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'

# used by apitome
require 'sprockets/railtie'

# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Elplano
  class Application < Rails::Application
    require_relative Rails.root.join('lib/middleware/health_check')
    require_relative Rails.root.join('lib/elplano/redis/wrapper')
    require_relative Rails.root.join('lib/elplano/redis/cache')

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    Rails.application.routes.default_url_options = {
      host: ENV['API_HOST'],
      tld_length: 1
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.eager_load_paths.push("#{config.root}/lib")
    config.eager_load_paths.push("#{Rails.root}/app/validators")

    #
    # This middleware needs to precede ActiveRecord::QueryCache and
    # other middlewares that connect to the database.
    #
    config.middleware.insert_after(Rails::Rack::Logger, ::Middleware::HealthCheck)

    #
    # Use caching across all environments
    #
    caching_config_hash = ::Elplano::Redis::Cache.params
    caching_config_hash[:namespace] = ::Elplano::Redis::Cache::CACHE_NAMESPACE

    #
    # Limit cache grow
    #
    caching_config_hash[:expires_in] = 2.weeks

    config.cache_store = :redis_store, caching_config_hash

    config.active_job.queue_adapter = :sidekiq
  end
end
