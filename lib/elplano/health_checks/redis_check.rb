# frozen_string_literal: true

module Elplano
  module HealthChecks
    # Elplano::HealthChecks::RedisCheck
    #
    #   Used to check REDIS health
    #
    class RedisCheck
      extend AbstractCheck

      class << self
        private

        def metric_prefix
          'redis_ping'
        end

        def successful?(result)
          result == 'PONG'
        end

        def check
          check_up_cache && check_up_queues
        end

        def check_up_cache
          ::Elplano::HealthChecks::Redis::CacheCheck.check_up
        end

        def check_up_queues
          ::Elplano::HealthChecks::Redis::QueuesCheck.check_up
        end
      end
    end
  end
end
