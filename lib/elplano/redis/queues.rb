# frozen_string_literal: true

module Elplano
  module Redis
    # Elplano::Redis::Queues
    #
    #   [...description...]
    #
    class Queues < ::Elplano::Redis::Wrapper
      class << self
        def options
          @options ||= {
            config_env_var_name: 'ELPLANO_REDIS_QUEUES_CONFIG_FILE',
            yaml_file_name: 'redis.sessions.yml',
            namespace: 'sidekiq:elplano',
            default_url: 'redis://localhost:6379/11'
          }
        end
      end
    end
  end
end
