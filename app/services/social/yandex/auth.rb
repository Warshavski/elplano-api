# frozen_string_literal: true

module Social
  module Yandex
    # Social::Yandex::Auth
    #
    #   Used to perform auth via yandex provider
    #
    class Auth < Social::Oauth
      USER_INFO_ENDPOINT = 'https://login.yandex.ru/info?format=json'

      private

      def configure_oauth_client(oauth_client)
        options = {
          site: 'https://oauth.yandex.com',
          token_url: '/token'
        }

        oauth_client.new(ENV['YANDEX_CLIENT_ID'], ENV['YANDEX_CLIENT_SECRET'], options)
      end

      def request_user_info!(token)
        payload = token.get(USER_INFO_ENDPOINT).parsed

        raise Api::UnprocessableAuth, :scope if payload['default_email'].blank?

        { user_id: payload['id'], email: payload['default_email'] }
      end

      def provider
        :yandex
      end
    end
  end
end
