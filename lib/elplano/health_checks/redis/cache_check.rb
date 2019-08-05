# frozen_string_literal: true

module Elplano
  module HealthChecks
    module Redis
      # Elplano::HealthChecks::Redis::CacheCheck
      #
      #   [DESCRIPTION]
      #
      class CacheCheck
        extend AbstractCheck

        class << self
          def check_up
            check
          end

          private

          def metric_prefix
            'redis_cache_ping'
          end

          def successful?(result)
            result == 'PONG'
          end

          def check
            catch_timeout(DEFAULT_TIMEOUT) { Elplano::Redis::Cache.with(&:ping) }
          end
        end
      end
    end
  end
end
