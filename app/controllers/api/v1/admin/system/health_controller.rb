# frozen_string_literal: true

module Api
  module V1
    module Admin
      module System
        # Api::V1::Admin::System::HealthController
        #
        #   Used to administrate system health status
        #
        class HealthController < Admin::ApplicationController
          denote_title_header 'System', 'Health'

          # GET : api/v1/admin/system/health?type=
          #
          #   query parameters :
          #
          #     - type  system health check type
          #              @example: ?type=readiness
          #
          # Get system health status
          #
          def show
            render_meta ::System::Health.call(params[:type])
          end
        end
      end
    end
  end
end
