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
          denote_title_header 'Emails', 'Metrics'

          # GET : api/v1/admin/emails/metrics
          #
          # Get emails metrics such as: clicks, delivered, opens
          #   (for last month)
          #
          def show
            render_meta fetch_metrics
          end

          private

          # TODO : create common caching logic
          def fetch_metrics
            cache_key         = 'emails_metrics'
            cache_expiration  = 5.minutes

            Rails.cache.fetch(cache_key, expires_in: cache_expiration) do
              ::Admin::Sendgrid::Metrics.call
            end
          end
        end
      end
    end
  end
end
