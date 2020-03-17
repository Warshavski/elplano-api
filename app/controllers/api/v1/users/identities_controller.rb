# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::IdentitiesController
      #
      #   Used to perform login through third party providers
      #
      class IdentitiesController < ApplicationController
        skip_before_action :authorize_access!, only: :create

        specify_title_header 'Users', 'Identities'

        specify_serializers default: ::Auth::UserSerializer

        # Return 401 - Unauthorized
        #
        rescue_from Api::UnprocessableAuth do |e|
          handle_error(e, :unauthorized) do
            [{ status: 401, detail: e.message, source: { pointer: "/attributes/#{e.param}" } }]
          end
        end

        # GET : api/v1/users/identities
        #
        #   Get a list of linked(connected) oauth providers
        #
        def index
          render_collection current_user.identities,
                            serializer: IdentitySerializer,
                            status: :ok
        end

        # POST : api/v1/users/identities
        #
        #   Perform sign in via oauth provider and link oauth provider
        #
        def create
          user = fabricate_provider
                 .then { |provider| provider.call(provider_params, user: current_user) }
                 .then { |identity| perform_sign_in(identity) }

          render_resource user,
                          include: %i[recent_access_token student],
                          status: :ok
        end

        # DELETE : api/v1/users/identities/:id
        #
        #   Destroy(unlink) oauth provider from current user's profile
        #
        def destroy
          find_provider!.then(&:destroy!)

          head :no_content
        end

        private

        def fabricate_provider
          Social::Factory.call(provider_params[:provider])
        end

        def perform_sign_in(identity)
          ::Users::SignIn.call(with: provider_params[:provider]) { sign_in(identity.user) }
        end

        def find_provider!
          current_user.identities.find(params[:id])
        end

        def provider_params
          validate_with(Identities::CreateContract.new, params[:identity])
        end
      end
    end
  end
end
