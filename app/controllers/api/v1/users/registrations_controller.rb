# frozen_string_literal: true

module Api
  module V1
    module Users
      # Api::V1::Users::RegistrationsController
      #
      #   Used to handle new user registration
      #
      class RegistrationsController < Devise::RegistrationsController
        set_default_serializer UserSerializer

        skip_before_action :doorkeeper_authorize!

        %i[cancel new edit update destroy].each do |method|
          define_method(method) { route_not_found }
        end

        # POST : api/v1/users
        #
        # Register new user in application
        #
        def create
          user = ::Users::Register.call { build_resource(sign_up_params) }

          if user.persisted?
            handle_auth(user)
          else
            handle_error(user)
          end
        end

        private

        def handle_auth(user)
          if user.active_for_authentication?
            #
            # Success!
            #
            message = find_message(:signed_up, {})

            sign_up(resource_name, user)
          else
            #
            # Success but activation required
            #
            message = find_message(:"signed_up_but_#{user.inactive_message}", {})
            expire_data_after_sign_in!
          end

          render_json user, meta: { message: message }, status: :created
        end

        def handle_error(user)
          clean_up_passwords(user)
          set_minimum_password_length

          render_errors(ErrorSerializer.serialize(user, 422), :unprocessable_entity)
        end

        def sign_up_params
          restify_param(:user)
            .require(:user)
            .permit(:username, :email, :email_confirmation, :password, :password_confirmation)
        end
      end
    end
  end
end
