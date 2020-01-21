# frozen_string_literal: true

module Social
  module Concerns
    # Social::Concerns::Registrable
    #
    #   Provides user registration add-ins
    #
    module Registrable
      def authenticate(user_params)
        find_identity(user_params[:user_id]) || perform_registration(user_params)
      end

      def perform_registration(user_params)
        User.transaction do
          find_or_register_user(user_params[:email]).then do |user|
            user.identities.public_send(provider).create!(uid: user_params[:user_id])
          end
        end
      end

      def find_identity(user_id)
        Identity.public_send(provider).find_by(uid: user_id)
      end

      def find_or_register_user(email)
        user = User.by_login(email)

        return user unless user.nil?

        params = {
          email: email,
          username: email
        }

        ::Users::Register.call do
          User.new(params.merge(password: temp_password), &:skip_confirmation!)
        end
      end

      def temp_password
        SecureRandom.hex(10)
      end

      def provider
        raise NotImplementedError
      end
    end
  end
end
