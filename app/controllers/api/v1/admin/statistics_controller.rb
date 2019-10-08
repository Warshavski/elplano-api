# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::StatisticsController
      #
      #   Application statistics management
      #
      class StatisticsController < Admin::ApplicationController
        denote_title_header 'Statistics'

        # GET : api/v1/admin/statistics
        #
        # Get application statistics data
        #
        def show
          render_meta fetch_statistics
        end

        private

        def fetch_statistics
          cache_key         = 'statistics_counters'
          cache_expiration  = 15.minutes

          Rails.cache.fetch(cache_key, expires_in: cache_expiration) do
            ::Admin::Statistics::Compose.call
          end
        end
      end
    end
  end
end
