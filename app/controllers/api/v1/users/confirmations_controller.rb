# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::ConfirmationsController
      #
      #   Used to confirm user registration
      #
      #     - confirms user registration
      #     - generate new confirmation token
      #
      class ConfirmationsController < Devise::ConfirmationsController
        include DeviseJsonApi

        skip_before_action :authorize_access!

        # GET : api/v1/users/confirmation/new
        def new
          route_not_found
        end

        # GET : api/v1/users/confirmation?confirmation_token=abcdef
        #
        # Confirm user registration
        #
        def show
          self.resource = resource_class.confirm_by_token(params[:confirmation_token])

          if resource.errors.empty?
            message = find_message(:confirmed, {})

            render_meta message: message
          else
            process_error(resource)
          end
        end

        # POST /api/v1/users/confirmation
        #
        # Generate confirmation token
        #
        def create
          self.resource = resource_class.send_confirmation_instructions(resource_params)

          if successfully_sent?(resource)
            render_meta message: @message
          else
            process_error(resource)
          end
        end
      end
    end
  end
end
