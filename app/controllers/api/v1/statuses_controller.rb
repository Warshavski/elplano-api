# frozen_string_literal: true

module Api
  module V1
    # Api::V1::StatusesController
    #
    #   Authenticated user status management
    #
    class StatusesController < ApplicationController
      specify_title_header 'Status'

      specify_serializers default: UserStatusSerializer

      # GET : api/v1/status
      #
      # Get authenticated user status
      #
      def show
        render_resource current_user.status, status: :ok
      end

      # PATCH/PUT : api/v1/status
      #
      # Update authenticated user status
      #
      def update
        status =
          ::Users::Status::Manage.call(:upsert, current_user, status_params)

        render_resource status, status: :ok
      end

      # DELETE : api/v1/status
      #
      # Delete authenticated user status
      #
      def destroy
        ::Users::Status::Manage.call(:destroy, current_user)

        head :no_content
      end

      private

      def status_params
        params.require(:user_status).permit(:emoji, :message)
      end
    end
  end
end
