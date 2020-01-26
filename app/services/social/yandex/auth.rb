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

      attr_reader :oauth_client, :authenticated_user

      def self.call(params, user: nil)
        new(user: user).execute(params)
      end

      def initialize(oauth_client = OAuth2::Client, user: nil)
        @authenticated_user = user

        @oauth_client = oauth_client.new(
          ENV['YANDEX_CLIENT_ID'],
          ENV['YANDEX_CLIENT_SECRET'],
          OAUTH2_OPTIONS
        )
      end

      def execute(params)
        fetch_user_data!(params[:code], params[:redirect_uri]).then do |user_data|
          authenticate(user_id: user_data['id'], email: user_data['default_email'])
        end
      end

      private

      def fetch_user_data!(code, redirect_uri)
        request_access_token!(code, redirect_uri).then(&method(:request_user_info!))
      rescue OAuth2::Error
        raise Api::UnprocessableAuth, :code
      end

      def request_access_token!(code, redirect_uri)
        oauth_client.auth_code.get_token(code, redirect_uri: redirect_uri).tap do |access_token|
          raise Api::UnprocessableAuth, :token if access_token.token.nil?
        end
      end

      def request_user_info!(token)
        token.get(USER_INFO_ENDPOINT).parsed.tap do |payload|
          raise Api::UnprocessableAuth, :scope if payload['default_email'].blank?
        end
      end

      def provider
        :yandex
      end
    end
  end
end
