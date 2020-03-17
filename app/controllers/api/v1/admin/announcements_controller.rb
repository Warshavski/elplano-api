# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::AnnouncementsController
      #
      #   Application announcements management
      #
      class AnnouncementsController < Admin::ApplicationController
        specify_title_header 'Announcements'

        specify_serializers default: AnnouncementSerializer

        # GET : api/v1/admin/announcements
        #
        # Get list of announcements
        #
        def index
          render_resource filter_announcements,
                          status: :ok
        end

        # GET : api/v1/admin/announcements/{:id}
        #
        # Get detailed information about application announcement
        #
        def show
          render_resource find_announcement(params[:id]),
                          status: :ok
        end

        # POST: api/v1/admin/announcements
        #
        # Create new application announcement
        #
        def create
          announcement = Announcement.create!(announcement_params)

          render_resource announcement, status: :created
        end

        # PATCH/PUT : api/v1/admin/announcements/{:id}
        #
        # Update application announcement
        #
        def update
          announcement = find_announcement(params[:id]).tap do |a|
            a.update!(announcement_params)
          end

          render_resource announcement, status: :ok
        end

        # DELETE : api/v1/admin/announcements/{:id}
        #
        # Delete application announcement
        #
        def destroy
          find_announcement(params[:id]).destroy!

          head :no_content
        end

        private

        def filter_announcements(_filters = {})
          Announcement.order(end_at: :desc)
        end

        def find_announcement(id)
          Announcement.find(id)
        end

        def announcement_params
          params
            .require(:announcement)
            .permit(:message, :start_at, :end_at, :background_color, :foreground_color)
        end
      end
    end
  end
end
