# frozen_string_literal: true

module Api
  module V1
    # Api::V1::UsersController
    #
    #   Used to represent information about current user
    #
    class UsersController < ApplicationController
      set_default_serializer UserSerializer

      # GET : api/v1/user
      #
      # Get information about current user
      #
      def show
        render_resource current_user, status: :ok
      end
    end
  end
end
