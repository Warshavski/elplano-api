# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::PasswordsController
      #
      #   Users password management (by application administrator)
      #
      class PasswordsController < ApplicationController
        specify_title_header 'Admin', 'Users', 'Password'

        # PATCH/PUT api/v1/admin/users/{:user_id}/password
        #
        # Update current password with a new one
        #
        def update
          find_user!.then { |user| reset_password!(user) }

          render_meta message: I18n.t(:'devise.passwords.updated_not_active')
        end

        private

        def find_user!
          User.find(params[:user_id])
        end

        def reset_password!(user)
          ::Admin::Users::Manage.call(user, :reset_password, password_params)
        end

        def password_params
          validate_with(::Admin::PasswordContract.new, params[:user])
        end
      end
    end
  end
end
