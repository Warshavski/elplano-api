# frozen_string_literal: true

module Social
  module Yandex
    # Social::Yandex::Auth
    #
    #   Used to perform auth via yandex provider
    #
    class Auth
      include Social::Concerns::Registrable

      USER_INFO_ENDPOINT = 'https://login.yandex.ru/info?format=json'

      OAUTH2_OPTIONS = {
        site: 'https://oauth.yandex.com',
        token_url: '/token'
      }.freeze

      attr_reader :oauth_client

      def self.call(params)
        new.execute(params)
      end

      def initialize(oauth_client = OAuth2::Client)
        @oauth_client = oauth_client.new(
          ENV['YANDEX_CLIENT_ID'],
          ENV['YANDEX_CLIENT_SECRET'],
          OAUTH2_OPTIONS
        )
      end

      def execute(params)
        fetch_user_data(params[:code], params[:redirect_uri]).then do |user_data|
          authenticate(user_id: user_data['id'], email: user_data['login'])
        end
      end

      private

      def fetch_user_data(code, redirect_uri)
        token = oauth_client.auth_code.get_token(code, redirect_uri: redirect_uri)

        raise Api::UnprocessableAuth, :token unless valid_token?(token)

        token.get(USER_INFO_ENDPOINT).parsed
      rescue OAuth2::Error
        raise Api::UnprocessableAuth, :code
      end

      def valid_token?(access_token)
        !access_token.token.nil?
      end

      def provider
        :yandex
      end
    end
  end
end
