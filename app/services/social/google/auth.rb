# frozen_string_literal: true

require 'google/apis/oauth2_v2'

module Social
  module Google
    # Social::Google::Auth
    #
    #   Used to perform auth via google provider
    #
    class Auth
      attr_reader :validator

      def self.call(code)
        new.execute(code)
      end

      def initialize(validator = ::Google::Apis::Oauth2V2::Oauth2Service.new)
        @validator = validator
      end

      def execute(code)
        user_data = fetch_user_data(code)
        return unless user_data

        find_identity(user_data) || perform_registration(user_data)
      end

      private

      def fetch_user_data(code)
        result = validator.tokeninfo(access_token: code)

        raise Api::UnprocessableAuth, :email if invalid_payload?(result)
        raise Api::UnprocessableAuth, :expired if expired?(result)
        raise Api::UnprocessableAuth, :audience if audience_mismatch?(result)

        result
      rescue ::Google::Apis::ClientError
        raise Api::UnprocessableAuth, :code
      end

      def invalid_payload?(result)
        result.email.blank?
      end

      def expired?(result)
        Time.at(result.expires_in).past?
      end

      def audience_mismatch?(result)
        ENV['GOOGLE_CLIENT_ID'] == result.audience
      end

      def find_identity(user_data)
        Identity.google.find_by(uid: user_data.user_id)
      end

      def perform_registration(user_data)
        user_params = {
          email: user_data.email,
          username: user_data.email
        }

        User.transaction do
          find_or_register_user(user_params).then do |user|
            user.identities.google.create!(uid: user_data.user_id)
          end
        end
      end

      def find_or_register_user(params)
        user = User.by_login(params[:email])

        user ||= ::Users::Register.call do
          User.new(params.merge(password: temp_password), &:skip_confirmation!)
        end

        user
      end

      def temp_password
        SecureRandom.hex(10)
      end
    end
  end
end
