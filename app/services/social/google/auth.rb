# frozen_string_literal: true

require 'google/apis/oauth2_v2'

module Social
  module Google
    # Social::Google::Auth
    #
    #   Used to perform auth via google provider
    #
    class Auth
      include Social::Concerns::Registrable

      attr_reader :validator

      def self.call(params)
        new.execute(params)
      end

      def initialize(validator = ::Google::Apis::Oauth2V2::Oauth2Service.new)
        @validator = validator
      end

      def execute(params)
        fetch_user_data(params[:code]).then do |user_data|
          authenticate(user_id: user_data.user_id, email: user_data.email)
        end
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
        ENV['GOOGLE_CLIENT_ID'] != result.audience
      end

      def provider
        :google
      end
    end
  end
end
