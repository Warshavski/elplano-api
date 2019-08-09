# frozen_string_literal: true

module Api
  module V1
    # Api::V1::PasswordsController
    #
    #   Authenticated user password management
    #
    class PasswordsController < ApplicationController
      required_params! :current_password, :password, :password_confirmation,
                       only: :update, scope: :user

      # PATCH/PUT api/v1/password
      #
      # Update current password with a new one
      #
      def update
        ::Users::Passwords::Change.call(current_user, password_params)

        render_meta message: I18n.t(:'devise.passwords.updated_not_active')
      end

      private

      def password_params
        params
          .require(:user)
          .permit(:current_password, :password, :password_confirmation)
      end
    end
  end
end
