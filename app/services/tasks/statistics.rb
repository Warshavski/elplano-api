# frozen_string_literal: true

module Tasks
  # Tasks::Statistics
  #
  #   Used to calculate statistics about tasks
  #
  class Statistics
    COUNTER_ATTRIBUTES =
      %w[outdated_count today_count tomorrow_count upcoming_count accomplished_count].freeze

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
      resolve_tasks_scope
        .then { |scope| perform_selection(scope) }
        .then { |result| format_result(result) }
    end

    private

    def resolve_tasks_scope
      appointed_tasks = student.appointed_tasks

      appointed_tasks.group(Assignment.arel_table[:student_id])
    end

    def perform_selection(scope)
      construct_query
        .then { |counters_query| scope.select(counters_query).take }
    end

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

    def format_result(result)
      result.nil? ? empty_counters : result.slice(COUNTER_ATTRIBUTES)
    end

    def empty_counters
      COUNTER_ATTRIBUTES.each_with_object({}) do |counter, result|
        result[counter] = 0
      end
    end
  end
end
