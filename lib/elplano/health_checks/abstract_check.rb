# frozen_string_literal: true

module Elplano
  module HealthChecks
    # Elplano::HealthChecks::AbstractCheck
    #
    #   Used to perform common functionality for any health check
    #
    module AbstractCheck
      DEFAULT_TIMEOUT = 10.seconds

      def name
        super.demodulize.underscore
      end

      def human_name
        name.sub(/_check$/, '').capitalize
      end

      def liveness
        HealthChecks::Result.new(true)
      end

      def readiness
        check_result = check

        if successful?(check_result)
          HealthChecks::Result.new(true)
        elsif check_result.is_a?(Timeout::Error)
          HealthChecks::Result.new(false, "#{human_name} check timed out")
        else
          HealthChecks::Result.new(false, "unexpected #{human_name} check result: #{check_result}")
        end
      end

      def metrics
        result, elapsed = with_timing(&method(:check))

        Rails.logger.error("#{human_name} check returned unexpected result #{result}") unless successful?(result)
        [
          metric("#{metric_prefix}_timeout", result.is_a?(Timeout::Error) ? 1 : 0),
          metric("#{metric_prefix}_success", successful?(result) ? 1 : 0),
          metric("#{metric_prefix}_latency_seconds", elapsed)
        ]
      end

      protected

      def metric(name, value, **labels)
        Metric.new(name, value, labels)
      end

      def with_timing
        start = Time.current

        yield.tap do |result|
          return [result, Time.current.to_f - start.to_f]
        end
      end

      def catch_timeout(seconds, &block)
        Timeout.timeout(seconds.to_i, &block)
      rescue Timeout::Error => error
        error
      end

      private

      def metric_prefix
        raise NotImplementedError
      end

      def successful?(_result)
        raise NotImplementedError
      end

      def check
        raise NotImplementedError
      end
    end
  end
end
