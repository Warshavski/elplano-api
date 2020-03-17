# frozen_string_literal: true

module Api
  module V1
    # Api::V1::AnnouncementsController
    #
    #   Retrieve current application announcements
    #
    class AnnouncementsController < ApplicationController
      specify_title_header 'Announcements'

      specify_serializers default: AnnouncementSerializer

      # GET : api/v1/announcements
      #
      # Get list of the current announcements
      #
      def index
        render_resource Announcement.current, status: :ok
      end
    end
  end
end
