# frozen_string_literal: true

module Admin
  module Statistics
    # Admin::Statistics::Compose
    #
    #   Used to prepare application statistics data
    #
    class Compose
      include Cacheable

      MODELS = [User, Group].freeze

      private_constant :MODELS

      cache_options key: 'statistics_counters', expires_in: 15.minutes

      # @see #execute
      def self.call
        new.execute
      end

      # Perform statistics composition
      #
      # @return [Hash]
      #
      # @example
      #   Admin::Statistics::Compose.call # =>
      #     {
      #       "user": {
      #         "total_count": 10,
      #         "week_count": 1,
      #         "month_count": 5
      #       },
      #       "group": {
      #         "total_count": 5,
      #         "week_count": 1,
      #         "month_count": 2
      #       }
      #     }
      #
      def execute
        MODELS.each_with_object({}) do |klass, statistics|
          stat_key = klass.name.downcase.to_sym

          statistics[stat_key] = count_statistics(klass)
        end
      end

      private

      def count_statistics(klass)
        %i[total week month].each_with_object({}) do |period, stats|
          stats[:"#{period}_count"] = resolve_scope(klass, period).count
        end
      end

      def resolve_scope(klass, period)
        return klass if period == :total

        klass.where(klass.arel_table[:created_at].gteq(resolve_start_point(period)))
      end

      def resolve_start_point(period)
        @start_points ||= {
          week: Date.current.beginning_of_week,
          month: Date.current.beginning_of_month
        }

        @start_points[period]
      end
    end
  end
end
