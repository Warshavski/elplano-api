# frozen_string_literal: true

module Elplano
  module HealthChecks
    module Redis
      # Elplano::HealthChecks::Redis::SessionsCheck
      #
      #   Used to check redis health for sessions
      #
      class SessionsCheck
        extend AbstractCheck

        class << self
          def check_up
            check
          end

          private

          def metric_prefix
            'redis_sessions_ping'
          end

          def successful?(result)
            result == 'PONG'
          end

          def check
            catch_timeout(DEFAULT_TIMEOUT) { Elplano::Redis::Sessions.with(&:ping) }
          end
        end
      end
    end
  end
end
