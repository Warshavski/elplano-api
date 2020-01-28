# frozen_string_literal: true

module Social
  module Facebook
    # Social::Facebook::Auth
    #
    #   Used to perform login via facebook OAuth2
    #
    class Auth < Social::Oauth
      USER_INFO_ENDPOINT = 'me'

      private

      def configure_oauth_client(oauth_client)
        options = {
          site: 'https://graph.facebook.com/v5.0',
          token_url: 'oauth/access_token'
        }

        oauth_client.new(ENV['FACEBOOK_CLIENT_ID'], ENV['FACEBOOK_CLIENT_SECRET'], options)
      end

      def request_user_info!(token)
        payload = token.get(USER_INFO_ENDPOINT, params: { fields: 'name,email' }).parsed

        { user_id: payload['id'], email: payload['email'] }
      end

      def provider
        :facebook
      end
    end
  end
end
