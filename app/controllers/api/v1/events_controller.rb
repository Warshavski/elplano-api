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
        render_json filter_events, status: :ok
      end

      # GET : api/v1/events/{:id}
      #
      # Get detailed information about event
      #
      def show
        event = filter_events.find(params[:id])

        render_json event, status: :ok
      end

      # POST : api/v1/events
      #
      # Creates(schedule) new event
      #
      def create
        event = current_student.created_events.create!(event_params)

        render_json event, status: :created
      end

      # PATCH/PUT : api/v1/events/{:id]}
      #
      # Updates/renew information about scheduled event
      #
      def update
        event = filter_events.find(params[:id])

        event.update!(event_params)

        render_json event, status: :ok
      end

      # DELETE : api/v1/events/{:id}
      #
      # Deletes scheduled event
      #
      def destroy
        event = filter_events.find(params[:id])

        event.destroy!

        head :no_content
      end

      private

      def filter_events(filters = {})
        current_student.created_events
      end

      def event_params
        restify_param(:event)
          .require(:event)
          .permit(
            :title, :description, :status,
            :start_at, :end_at, :timezone,
            :course_id,
            recurrence: []
          )
      end
    end
  end
end
