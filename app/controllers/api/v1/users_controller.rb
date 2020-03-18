# frozen_string_literal: true

module Api
  module V1
    # Api::V1::UsersController
    #
    #   Used to represent information about current user
    #
    class UsersController < ApplicationController
      specify_title_header 'User'

      specify_serializers default: UserSerializer

      rescue_from Errno::ENOENT, KeyError do |e|
        handle_error(e, :bad_request) do
          [{ status: 400, detail: e.message, source: { pointer: '/data/attributes/avatar' } }]
        end
      end

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

      # DELETE : api/v1/user
      #
      # Delete user with all related data
      #   (PERMANENT ACTION)
      #
      def destroy
        authorize! owner_params[:password], with: PasswordPolicy

        ::Users::Destroy.call(current_user)

        head :no_content
      end

      private

      def user_params
        user_attributes = [:locale, :avatar, :timezone, settings: {}]
        student_attributes = [
          :full_name, :email, :phone, :about, :gender, :birthday, social_networks: {}
        ]

        permitted = params
                    .require(:user)
                    .permit(*user_attributes, student_attributes: student_attributes)

        permitted.tap { |p| p.dig(:student_attributes)&.merge!(id: current_student.id) }
      end

      def owner_params
        validate_with(::Users::DestroyContract.new, params[:user])
      end
    end
  end
end
