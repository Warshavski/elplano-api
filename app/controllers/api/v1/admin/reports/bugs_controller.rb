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
          denote_title_header 'Admin', 'Reports', 'Bugs'

          set_default_serializer ::BugReportSerializer

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
          # Get bug report by it's identity
          #
          def show
            render_resource find_report!(params[:id]), status: :ok
          end

          # DELETE : api/v1/admin/reports/bugs/{:id}
          #
          # Delete bug report by it's identity
          #
          def destroy
            find_report!(params[:id]).tap(&:destroy!)

            head :no_content
          end

          private

          def find_report!(id)
            filter_reports.find(id)
          end

          def filter_reports(filters = {})
            BugReportsFinder.new(filters).execute
          end

          def filter_params
            super(::Admin::Reports::Bugs::IndexContract)
          end
        end
      end
    end
  end
end
