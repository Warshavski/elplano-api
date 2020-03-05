# frozen_string_literal: true

module Elplano
  module Redis
    # Elplano::Redis::Queues
    #
    #   [...description...]
    #
    class Sessions < ::Elplano::Redis::Wrapper
      class << self
        def options
          @options ||= {
            config_env_var_name: 'ELPLANO_REDIS_SESSIONS_CONFIG_FILE',
            yaml_file_name: 'redis.sessions.yml',
            namespace: 'session:elplano',
            default_url: 'redis://localhost:6379/12'
          }
        end

        def lookup_namespaces(name)
          @lookup_namespaces[name] unless @lookup_namespaces.nil?

          @lookup_namespaces ||= {
            user_sessions: 'session:lookup:user:elplano'
          }

          @lookup_namespaces[name]
        end
      end
    end
  end
end
