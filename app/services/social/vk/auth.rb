# frozen_string_literal: true

module Social
  module Vk
    # Social::Vk::Auth
    #
    #   Used to perform auth via vkontakte provider
    #
    class Auth < Social::Oauth

      private

      def configure_oauth_client(oauth_client)
        options = {
          site: 'https://oauth.vk.com',
          authorize_url: '/authorize',
          token_url: '/access_token'
        }

        oauth_client.new(ENV['VK_CLIENT_ID'], ENV['VK_CLIENT_SECRET'], options)
      end

      def request_user_info!(token)
        payload = token.params

        raise Api::UnprocessableAuth, :email if payload['email'].blank?

        { user_id: payload['user_id'], email: payload['email'] }
      end

      def provider
        :vk
      end
    end
  end
end
