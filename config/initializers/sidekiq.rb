#
# Custom Queues configuration
#
queues_config_hash = Elplano::Redis::Queues.params
queues_config_hash[:namespace] = Elplano::Redis::Queues::SIDEKIQ_NAMESPACE

#
# Default is to retry 25 times with exponential backoff.
# That's too much.
#
Sidekiq.default_worker_options = { retry: 3 }

Sidekiq.configure_server do |config|
  config.redis = queues_config_hash

  config.on :startup do
    #
    # Clear any connections that might have been obtained before starting
    # Sidekiq (e.g. in an initializer).
    #
    ActiveRecord::Base.clear_all_connections!
  end

  db_config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]

  db_config['pool'] = Sidekiq.options[:concurrency]
  ActiveRecord::Base.establish_connection(db_config)
  Rails.logger.debug("Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
end

Sidekiq.configure_client do |config|
  config.redis = queues_config_hash
end
