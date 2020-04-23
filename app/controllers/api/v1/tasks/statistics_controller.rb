# frozen_string_literal: true

module Api
  module V1
    module Tasks
      # Api::V1::Tasks::StatisticsController
      #
      #   Used to show statistics for tasks assigned to current user
      #
      class StatisticsController < ApplicationController
        specify_title_header 'Tasks', 'Statistics'

        # GET : api/v1/tasks/statistics
        #
        # Get stat counters for tasks assigned to authenticated user(student)
        #
        def show
          # TODO : think about caching(strategy, expiration...)
          render_meta ::Tasks::Statistics.call(current_student)
        end
      end
    end
  end
end
