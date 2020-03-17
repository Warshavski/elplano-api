# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Emails
        # Api::V1::Admin::Emails::MetricsController
        #
        #   Emails metrics management
        #
        class MetricsController < Admin::ApplicationController
          specify_title_header 'Emails', 'Metrics'

          # GET : api/v1/admin/emails/metrics
          #
          # Get emails metrics such as: clicks, delivered, opens
          #   (for last month)
          #
          def show
            render_meta ::Admin::Sendgrid::Metrics.cached_call
          end
        end
      end
    end
  end
end
