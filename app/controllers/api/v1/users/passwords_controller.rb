# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::PasswordsController
      #
      #   Used to reset user's password
      #
      class PasswordsController < Devise::PasswordsController
        include DeviseJsonApi

        skip_before_action :authorize_access!

        # GET : api/v1/accounts/password/new
        def new
          route_not_found
        end

        # GET : api/v1/users/password/edit?reset_password_token=abcdef
        def edit
          route_not_found
        end

        # POST : api/v1/users/password
        #
        # Create reset password token and send email
        #
        def create
          self.resource = resource_class.send_reset_password_instructions(resource_params)

          if successfully_sent?(resource)
            render_meta message: @message
          else
            process_error(resource)
          end
        end

        # PATCH/PUT : api/v1/users/password
        #
        # Execute reset password
        #
        def update
          self.resource = resource_class.reset_password_by_token(resource_params)

          if resource.errors.empty?
            update_state!

            render_resource resource, meta: { message: @message }, status: :ok
          else
            process_error(resource) { set_minimum_password_length }
          end
        end

        private

        def update_state!
          resource.unlock_access! if unlockable?(resource)

          message_kind = if Devise.sign_in_after_reset_password
                           resource.active_for_authentication? ? :updated : :updated_not_active
                         else
                           :updated_not_active
                         end

          @message = find_message(message_kind, {})
        end

        def resource_params
          restify_param(:user)
            .require(:user)
            .permit(:login, :password, :password_confirmation, :reset_password_token)
        end
      end
    end
  end
end
