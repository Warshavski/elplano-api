# frozen_string_literal: true

module Social
  module Google
    # Social::Google::Auth
    #
    #   Used to perform auth via google provider
    #
    class Auth
      include Social::Concerns::Registrable

      USER_INFO_ENDPOINT = 'https://openidconnect.googleapis.com/v1/userinfo'

      OAUTH2_OPTIONS = {
        site: 'https://oauth2.googleapis.com',
        token_url: '/token'
      }.freeze

      attr_reader :oauth_client

      def self.call(params)
        new.execute(params)
      end

      def initialize(oauth_client = OAuth2::Client)
        @oauth_client = oauth_client.new(
          ENV['GOOGLE_CLIENT_ID'],
          ENV['GOOGLE_CLIENT_SECRET'],
          OAUTH2_OPTIONS
        )
      end

      def execute(params)
        fetch_user_data(params[:code]).then do |user_data|
          authenticate(user_id: user_data['sub'], email: user_data['email'])
        end
      end

      private

      def fetch_user_data(code)
        token = oauth_client.auth_code.get_token(code, redirect_uri: 'postmessage')

        raise Api::UnprocessableAuth, :token unless valid_token?(token)

        token.get(USER_INFO_ENDPOINT).then(&:parsed)
      rescue OAuth2::Error
        raise Api::UnprocessableAuth, :code
      end

      def valid_token?(access_token)
        !access_token.token.nil?
      end

      def provider
        :google
      end
    end
  end
end
