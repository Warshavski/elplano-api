# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::StatisticsController
      #
      #   Application statistics management
      #
      class StatisticsController < Admin::ApplicationController
        specify_title_header 'Statistics'

        # GET : api/v1/admin/statistics
        #
        def show
          render_meta ::Admin::Statistics::Compose.cached_call
        end
      end
    end
  end
end
