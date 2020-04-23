# frozen_string_literal: true

module Tasks
  # Tasks::Statistics
  #
  #   Used to calculate statistics about tasks
  #
  class Statistics
    attr_reader :student

    # @see #execute
    #
    def self.call(student)
      new(student).execute
    end

    # @param [Student] student -
    #   A student in the scope of which tasks statistics are calculated
    #
    def initialize(student)
      @student = student
    end

    # Calculate tasks statistics(grouped counters)
    #
    # @return [Hash]
    #
    def execute
      counters = %w[outdated_count today_count tomorrow_count upcoming_count accomplished_count]
      counters_query = construct_query

      resolve_tasks_scope
        .then { |scope| scope.select(counters_query).take }
        .then { |results| results.slice(counters) }
    end

    private

    def construct_query
      current_date  = Date.current
      tomorrow_date = current_date + 1.day

      <<~SQL.squish
        COUNT(*) FILTER (WHERE assignments.accomplished = false AND tasks.expired_at < '#{current_date}') AS outdated_count,
        COUNT(*) FILTER (WHERE assignments.accomplished = false AND tasks.expired_at = '#{current_date}') AS today_count,
        COUNT(*) FILTER (WHERE assignments.accomplished = false AND tasks.expired_at = '#{tomorrow_date}') AS tomorrow_count,
        COUNT(*) FILTER (WHERE assignments.accomplished = false AND tasks.expired_at > '#{tomorrow_date}') AS upcoming_count,
        COUNT(*) FILTER (WHERE assignments.accomplished = true) AS accomplished_count
      SQL
    end

    def resolve_tasks_scope
      student.appointed_tasks.joins(:appointments)
    end
  end
end
