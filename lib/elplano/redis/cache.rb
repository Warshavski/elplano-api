# frozen_string_literal: true

module Elplano
  module Redis
    # Elplano::Redis::Cache
    #
    #   [...description...]
    #
    class Cache < ::Elplano::Redis::Wrapper
      class << self
        def options
          @options ||= {
            config_env_var_name: 'ELPLANO_REDIS_CACHE_CONFIG_FILE',
            yaml_file_name: 'redis.cache.yml',
            namespace: 'cache:elplano',
            default_url: 'redis://localhost:6379/10'
          }
        end
      end
    end
  end
end
