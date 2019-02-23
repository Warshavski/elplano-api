# frozen_string_literal: true

# please require all dependencies below:
require_relative 'wrapper' unless defined?(::Elplano::Redis::Wrapper)

module Elplano
  module Redis
    # Elplano::Redis::Queues
    #
    #   [...description...]
    #
    class Queues < ::Elplano::Redis::Wrapper
      SIDEKIQ_NAMESPACE = 'sidekiq:elplano'
      DEFAULT_REDIS_QUEUES_URL = 'redis://localhost:6381'
      REDIS_QUEUES_CONFIG_ENV_VAR_NAME = 'ELPLANO_REDIS_QUEUES_CONFIG_FILE'

      class << self
        def default_url
          DEFAULT_REDIS_QUEUES_URL
        end

        def config_file_name
          #
          # if ENV set for this class, use it even if it points to a file does not exist
          #
          file_name = ENV[REDIS_QUEUES_CONFIG_ENV_VAR_NAME]
          return file_name if file_name

          #
          # otherwise, if config files exists for this class, use it
          #
          file_name = config_file_path('redis.queues.yml')
          return file_name if File.file?(file_name)

          #
          # this will force use of DEFAULT_REDIS_QUEUES_URL when config file is absent
          #
          super
        end
      end
    end
  end
end
