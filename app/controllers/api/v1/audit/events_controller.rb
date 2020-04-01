# frozen_string_literal: true

module Api
  module V1
    module Audit
      # Api::V1::Audit::EventsController
      #
      #   Retrieve authenticated user's audit evens
      #
      class EventsController < ApplicationController
        specify_title_header 'Audit', 'Events'

        specify_serializers default: AuditEventSerializer

        # GET : api/v1/audit/events
        #
        #   optional filter parameters :
        #
        #     - type - Filter by audit event type(authentication, permanent_action)
        #
        # @see #filter_params
        #
        # Get list of authenticate user audit events
        #
        def index
          render_collection filter_events(filter_params), status: :ok
        end

        private

        def filter_events(filters = {})
          AuditEventsFinder.call(context: current_user, params: filters)
        end

        def filter_params
          super(::Audit::Events::IndexContract)
        end
      end
    end
  end
end
