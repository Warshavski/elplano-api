# frozen_string_literal: true

module Social
  module Google
    # Social::Google::Auth
    #
    #   Used to perform auth via google provider
    #
    class Auth < Social::Oauth
      USER_INFO_ENDPOINT = 'https://openidconnect.googleapis.com/v1/userinfo'

      private

      def configure_oauth_client(oauth_client)
        options = {
          site: 'https://oauth2.googleapis.com',
          token_url: '/token'
        }

        oauth_client.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], options)
      end

      def request_access_token!(code, redirect_uri = 'postmessage')
        super
      end

      def request_user_info!(token)
        payload = token.get(USER_INFO_ENDPOINT).parsed

        { user_id: payload['sub'], email: payload['email'] }
      end

      def provider
        :google
      end
    end
  end
end
