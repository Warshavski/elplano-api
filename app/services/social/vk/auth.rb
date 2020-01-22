# frozen_string_literal: true

module Social
  module Vk
    # Social::Vk::Auth
    #
    #   Used to perform auth via vkontakte provider
    #
    class Auth
      include Social::Concerns::Registrable

      OPTIONS = {
        site: 'https://oauth.vk.com',
        authorize_url: '/authorize',
        token_url: '/access_token'
      }.freeze

      attr_reader :oauth_client

      def self.call(params)
        new.execute(params)
      end

      def initialize(oauth_client = OAuth2::Client)
        @oauth_client =
          oauth_client.new(ENV['VK_CLIENT_ID'], ENV['VK_CLIENT_SECRET'], OPTIONS)
      end

      def execute(params)
        fetch_user_data(params[:code], params[:redirect_uri]).then do |user_data|
          authenticate(user_id: user_data['user_id'], email: user_data['email'])
        end
      end

      private

      def fetch_user_data(code, redirect_uri)
        token = oauth_client.auth_code.get_token(code, redirect_uri: redirect_uri)

        raise Api::UnprocessableAuth, :email if invalid_token?(token)

        token.params
      rescue OAuth2::Error
        raise Api::UnprocessableAuth, :code
      end

      def invalid_token?(client)
        client.params['email'].nil?
      end

      def provider
        :vk
      end
    end
  end
end
