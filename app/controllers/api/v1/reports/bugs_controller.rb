# frozen_string_literal: true

module Api
  module V1
    module Reports
      # Api::V1::BugReportsController
      #
      #   [DESCRIPTION]
      #
      class BugsController < ApplicationController
        denote_title_header 'Reports', 'Bugs'

        # POST : api/v1/reports/bugs
        #
        # Report bug(create bug report)
        #
        def create
          current_user.reported_bugs.create!(report_params)

          render_meta({ message: I18n.t('generic.messages.received') }, status: :created)
        end

        private

        def report_params
          params.require(:report).permit(:message)
        end
      end
    end
  end
end
