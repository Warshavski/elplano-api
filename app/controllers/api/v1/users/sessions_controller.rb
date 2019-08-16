# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::SessionsController
      #
      #   User authentication management
      #     (SignIn, SignOut)
      #
      class SessionsController < Devise::SessionsController
        set_default_serializer ::Auth::UserSerializer

        skip_before_action :authorize_access!, only: %i[new create]
        skip_before_action :verify_signed_out_user

        # GET :  api/v1/users/sign_in
        def new
          route_not_found
        end

        # POST : api/v1/users/sign_in
        #
        # Perform user login into the application
        #   (claim access token and return detailed user info)
        #
        def create
          self.resource = ::Users::SignIn.call { warden.authenticate!(auth_options) }

          message = find_message(:signed_in, {})

          render_resource resource,
                          include: %i[recent_access_token student],
                          meta: { message: message },
                          status: :created
        end

        # DELETE : api/v1/users/sign_out
        #
        # TODO : implement sign out
        #
        def destroy
          route_not_found
        end
      end
    end
  end
end
