# frozen_string_literal: true

module System
  # System::Health
  #
  #   Used to perform system health checks
  #
  class Health
    CHECKS = [
      Elplano::HealthChecks::DbCheck,
      Elplano::HealthChecks::RedisCheck,
      Elplano::HealthChecks::Redis::CacheCheck,
      Elplano::HealthChecks::Redis::QueuesCheck
    ].freeze

    CHECK_TYPES = %i[liveness readiness].freeze

    # (see #execute)
    def self.call(check_type)
      new.execute(check_type)
    end

    # Perform system components health checks
    #   (such as redis and db)
    #
    # @param check_type [String, Symbol] -
    #   Health check type identity(:liveiness, :readiness)
    #
    # @return [Hash] System component name => results
    #
    def execute(check_type)
      return {} unless CHECK_TYPES.include?(check_type.to_sym)

      results = perform_checks(check_type.to_sym)

      compose_results(results)
    end

    private

    def perform_checks(type)
      CHECKS.map do |check|
        [check.name, check.public_send(type)]
      end
    end

    def compose_results(results)
      results.each_with_object({}) do |(name, info), memo|
        memo[name] = info.to_h
      end
    end
  end
end
