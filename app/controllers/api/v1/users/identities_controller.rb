# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::IdentitiesController
      #
      #   Used to perform login through third party providers
      #
      class IdentitiesController < ApplicationController
        skip_before_action :authorize_access!, only: %i[new create]

        set_default_serializer ::Auth::UserSerializer

        denote_title_header 'Users', 'Identities'

        # Return 401 - Unauthorized
        #
        rescue_from Api::UnprocessableAuth do |e|
          handle_error(e, :unauthorized) do
            [{ status: 401, detail: e.message, source: { pointer: "/attributes/#{e.param}" } }]
          end
        end

        # POST : api/v1/users/identity
        #
        #   Perform sign in via social provider
        #
        def create
          user = fabricate_provider
                 .then { |provider| provider.call(provider_params[:code]) }
                 .then { |identity| perform_sign_in(identity) }

          render_resource user,
                          include: %i[recent_access_token student],
                          status: :ok
        end

        private

        def fabricate_provider
          Social::Factory.call(provider_params[:provider])
        end

        def perform_sign_in(identity)
          ::Users::SignIn.call { sign_in(identity.user) }
        end

        def provider_params
          params.require(:identity).permit(:code, :provider)
        end
      end
    end
  end
end
