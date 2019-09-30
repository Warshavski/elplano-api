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
        skip_before_action :authorize_access!, only: %i[new create]
        skip_before_action :verify_signed_out_user

        set_default_serializer ::Auth::UserSerializer

        denote_title_header 'Users'

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
        # Perform access token revoke for authenticated user
        #
        def destroy
          Doorkeeper::AccessToken.revoke_all_for(nil, current_user)

          render_meta message: I18n.t('devise.sessions.signed_out')
        end
      end
    end
  end
end
