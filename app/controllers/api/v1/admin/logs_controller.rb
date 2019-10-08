# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::LogsController
      #
      #   Logs management
      #
      class LogsController < Admin::ApplicationController
        denote_title_header 'Logs'

        # GET : api/v1/admin/logs
        #
        #  Get logs
        #
        def show
          render_meta ::Admin::Logs::Fetch.call
        end
      end
    end
  end
end
