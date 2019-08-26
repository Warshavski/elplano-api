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
        render_resource current_user,
                        include: [:student],
                        status: :ok
      end

      # PATCH/PUT : api/v1/user
      #
      # Update authenticated user
      #
      def update
        current_user.update!(user_params)

        render_resource current_user,
                        include: [:student],
                        status: :ok
      end

      private

      def user_params
        user_attributes = %i[locale avatar]
        student_attributes = [:full_name, :email, :phone, :about, social_networks: {}]

        permitted = params
                    .require(:user)
                    .permit(*user_attributes, student_attributes: student_attributes)

        permitted.tap { |p| p.dig(:student_attributes)&.merge!(id: current_student.id) }
      end
    end
  end
end
