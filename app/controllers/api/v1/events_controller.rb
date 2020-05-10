# frozen_string_literal: true

module Api
  module V1
    # Api::V1::EventsController
    #
    #   Used to manage events.
    #
    #   Actions available for every student(group member):
    #
    #     - Get list of the student's events.
    #     - Get information about particular event(detailed information).
    #     - Create a new personal event for himself(schedule event).
    #     - Update a personal event(created for himself).
    #     - Delete a personal event(created for himself).
    #
    #   Actions available for group owner(group president):
    #
    #     - Create a new group event or personal event for any group member.
    #     - Update information about any created event(group and personal for any member).
    #     - Delete event any created event(group and personal for any member).
    #
    class EventsController < ApplicationController
      specify_serializers default: EventSerializer

      specify_title_header 'Events'

      # GET : api/v1/events
      #
      #   optional query parameters :
      #
      #     - scope   filter by event scope:
      #
      #                 - authored - created by current student
      #                 - appointed - created for current student
      #
      #                @example: ?scope=authored
      #
      #     - type   filter by event type:
      #
      #                 - group - created for whole current student's group
      #                 - personal - create only for current user
      #
      #                @example: ?type=personal
      #
      #     - labels filter by labels attached to the event
      #
      #                 @example: ?labels=wat,so,label
      #
      # Get list of student's events
      #
      def index
        events = filter_events(filter_params).preload(:eventable, :labels)

        render_collection events, include: [:labels], status: :ok
      end

      # GET : api/v1/events/{:id}
      #
      # Get detailed information about event
      #
      def show
        scope = filter_events.or(filter_events(scope: 'authored'))

        event = scope.find(params[:id])

        render_resource event, include: [:labels], status: :ok
      end

      # POST : api/v1/events
      #
      # Creates(schedule) new event
      #
      def create
        event = ::Events::Create.call(current_student, event_params) do |e|
          authorize! e
        end

        render_resource event, include: [:labels], status: :created
      end

      # PATCH/PUT : api/v1/events/{:id]}
      #
      # Updates/renew information about scheduled event
      #
      def update
        event = find_and_perform!(params[:id]) do |e|
          ::Events::Update.call(e, event_params)
        end

        render_resource event, include: [:labels], status: :ok
      end

      # DELETE : api/v1/events/{:id}
      #
      # Deletes scheduled event
      #
      def destroy
        find_and_perform!(params[:id], &:destroy!)

        head :no_content
      end

      private

      def filter_events(filters = {})
        EventsFinder.call(context: current_student, params: filters)
      end

      def filter_params
        super(::Events::IndexContract)
      end

      def find_and_perform!(id)
        scope = filter_events(scope: 'authored')

        scope.find(id).tap do |event|
          authorize! event
          yield(event)
        end
      end

      def event_params
        params
          .require(:event)
          .permit(
            :title, :description, :status,
            :start_at, :end_at, :timezone,
            :background_color, :foreground_color,
            :course_id, :eventable_id, :eventable_type,
            recurrence: [], label_ids: []
          )
      end
    end
  end
end
