# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'

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

    Rails.application.routes.default_url_options = { host: 'localhost', tld_length: 1 }

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

    # Configure sensitive parameters which will be filtered from the log file.
    #
    # Parameters filtered:
    #
    #   - Any parameter ending with `token`
    #   - Any parameter containing `password`
    #   - Any parameter containing `secret`
    #   - Any parameter ending with `key`
    #
    config.filter_parameters += [/token$/, /password/, /secret/, /key$/]

    #
    # Allow access to El Plano API from other domains
    #
    config.middleware.insert_before(0, Rack::Cors) do
      #
      # Cross-origin requests must not have the session cookie available
      #
      allow do
        origins '*'
        resource '*',
                 credentials: false,
                 headers: :any,
                 methods: :any,
                 expose: %w[Link X-Total X-Total-Pages X-Per-Page X-Page X-Next-Page X-Prev-Page]
      end
    end

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
  end
end
