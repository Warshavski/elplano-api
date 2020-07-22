# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Reports
        # Api::V1::Admin::Reports::BugsController
        #
        #   Manage bugs reports
        #
        class BugsController < Admin::ApplicationController
          specify_title_header 'Admin', 'Reports', 'Bugs'

          specify_serializers default: ::BugReportSerializer

          # GET : api/v1/admin/reports/bugs
          #
          #   optional filter parameters :
          #
          #     - user_id - Filter by the reporter
          #
          # @see #filter_params
          #
          # Filter list of bug reports
          #
          def index
            render_collection filter_reports(filter_params), status: :ok
          end

          # GET : api/v1/admin/reports/bugs/{:id}
          #
          def show
            render_resource find_report!(params[:id]), status: :ok
          end

          # DELETE : api/v1/admin/reports/bugs/{:id}
          #
          def destroy
            find_report!(params[:id]).destroy!

            head :no_content
          end

          private

          def find_report!(id)
            filter_reports.find(id)
          end

          def filter_reports(filters = {})
            BugReportsFinder.call(params: filters)
          end

          def filter_params
            super(::Admin::Reports::Bugs::IndexContract)
          end
        end
      end
    end
  end
end
