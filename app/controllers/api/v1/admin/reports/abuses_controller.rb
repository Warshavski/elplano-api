# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Reports
        # Api::V1::Admin::Reports::AbusesController
        #
        #   Manage abuses reports
        #
        class AbusesController < Admin::ApplicationController
          specify_title_header 'Reports', 'Abuses'

          specify_serializers default: ::AbuseReportSerializer

          # GET : api/v1/admin/reports/abuses
          #
          #   optional filter parameters :
          #
          #     - user_id       - Filter by the reported user
          #     - reporter_id   - Filter by the reporter
          #
          # @see #filter_params
          #
          # Filter list of abuse reports
          #
          def index
            render_collection filter_reports(filter_params), status: :ok
          end

          # GET : api/v1/admin/reports/abuses/{:id}
          #
          # Get abuse report by it's identity
          #
          def show
            render_resource find_report!(params[:id]),
                            include: %i[reporter user],
                            status: :ok
          end

          # DELETE : api/v1/admin/reports/abuses/{:id}
          #
          # Delete abuse report by it's identity
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
            AbuseReportsFinder.call(params: filters)
          end

          def filter_params
            super(::Admin::Reports::Abuses::IndexContract)
          end
        end
      end
    end
  end
end
