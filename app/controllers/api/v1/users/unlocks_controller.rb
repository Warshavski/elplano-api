# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::UnlocksController
      #
      #   Used to unlock users
      #
      #     - create link to unlock user + letter send
      #     - unlock user by link from letter
      #
      class UnlocksController < Devise::UnlocksController
        include DeviseJsonApi

        # GET :  api/v1/users/unlock/new
        def new
          route_not_found
        end

        # GET : api/v1/users/unlock?unlock_token=abcdef
        #
        # Unlock user
        #
        def show
          self.resource = unlock_access(params[:unlock_token])

          if resource.errors.empty?
            message = find_message(:unlocked, {})

            render_json resource, meta: { message: message }, status: :ok
          else
            handle_error(resource)
          end
        end

        # POST : api/v1/users/unlock
        #
        # Create unlock token
        #
        def create
          self.resource = resource_class.send_unlock_instructions(resource_params)

          if successfully_sent?(resource)
            render_json resource, meta: { message: @message }, status: :ok
          else
            handle_error(resource)
          end
        end

        private

        def unlock_access(token)
          resource_class.unlock_access_by_token(token)
        end
      end
    end
  end
end
