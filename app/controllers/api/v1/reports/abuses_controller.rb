# frozen_string_literal: true

module Api
  module V1
    module Reports
      # Api::V1::Reports::AbusesController
      #
      #   User's abuse reports management
      #
      #     - report user
      #
      class AbusesController < ApplicationController
        specify_title_header 'Reports', 'Abuses'

        # POST : api/v1/reports/abuses
        #
        # Create(register) new abuse report
        #
        def create
          current_user.reported_abuses.create!(report_params)

          render_meta({ message: I18n.t(:'generic.messages.received') }, status: :created)
        end

        private

        def report_params
          params.require(:report).permit(:message, :user_id)
        end
      end
    end
  end
end
