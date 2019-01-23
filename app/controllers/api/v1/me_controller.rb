module Api
  module V1
    # Api::V1::MeController
    #
    #   Used to represent current user information
    #
    class MeController < ApplicationController
      set_default_serializer MeSerializer

      # GET : api/v1/me
      #
      # Get information about current user
      #
      def show
        render_json current_user, status: :ok
      end
    end
  end
end
