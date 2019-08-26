# frozen_string_literal: true

module Api
  module V1
    # Api::V1::EventsController
    #
    #   Used to control events in scope of current user
    #
    #     - list created events
    #     - get information about particular event(detailed information)
    #     - create a new event(schedule event)
    #     - update information about event
    #     - delete event
    #
    class EventsController < ApplicationController
      set_default_serializer EventSerializer

      # GET : api/v1/events
      #
      # Get list of events
      #
      def index
        render_resource filter_events, status: :ok
      end

      # GET : api/v1/events/{:id}
      #
      # Get detailed information about event
      #
      def show
        event = filter_events.find(params[:id])

        render_resource event, status: :ok
      end

      # POST : api/v1/events
      #
      # Creates(schedule) new event
      #
      def create
        event = ::Events::Create.call(current_student, event_params) do |e|
          authorize! e
        end

        render_resource event, status: :created
      end

      # PATCH/PUT : api/v1/events/{:id]}
      #
      # Updates/renew information about scheduled event
      #
      def update
        event = filter_events.find(params[:id])

        event.update!(event_params)

        render_resource event, status: :ok
      end

      # DELETE : api/v1/events/{:id}
      #
      # Deletes scheduled event
      #
      def destroy
        filter_events.find(params[:id]).tap(&:destroy!)

        head :no_content
      end

      private

      def filter_events(_filters = {})
        current_student.created_events
      end

      def event_params
        params
          .require(:event)
          .permit(
            :title, :description, :status,
            :start_at, :end_at, :timezone,
            :course_id, :eventable_id, :eventable_type,
            recurrence: []
          )
      end
    end
  end
end
