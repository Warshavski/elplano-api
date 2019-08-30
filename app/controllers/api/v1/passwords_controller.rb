# frozen_string_literal: true

module Api
  module V1
    # Api::V1::PasswordsController
    #
    #   Authenticated user password management
    #
    class PasswordsController < ApplicationController
      denote_title_header 'Password'

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
        validate_with(PasswordContract.new, params[:user])
      end
    end
  end
end
