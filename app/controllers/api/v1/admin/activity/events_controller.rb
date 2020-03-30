# frozen_string_literal: true

module Api
  module V1
    module Admin
      module Activity
        # Api::V1::Admin::Activity::EventsController
        #
        #   Used to observ users activity events
        #     (activity feed)
        #
        class EventsController < Admin::ApplicationController
          specify_title_header 'Activity', 'Events'

          specify_serializers default: ::ActivityEventSerializer

          # GET : api/v1/admin/activity/events
          #
          #   optional filter parameters :
          #
          #     - action  - Filter by activity events by action(created, updated)
          #     - user_id - Filter by user
          #
          # @see #filter_params
          #
          # Get list of activity events
          #
          def index
            activity_feed = filter_events(filter_params).preload(:target, :author)

            render_collection activity_feed,
                              include: %i[target author],
                              status: :ok
          end

          private

          def filter_events(filters = {})
            ActivityEventsFinder.call(params: filters)
          end

          def filter_params
            super(::Admin::Activity::Events::IndexContract)
          end
        end
      end
    end
  end
end
