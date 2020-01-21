# frozen_string_literal: true

module Social
  module Vk
    # Social::Vk::Auth
    #
    #   Used to perform auth via vkontakte provider
    #
    class Auth
      include Social::Concerns::Registrable

      attr_reader :validator

      def self.call(params)
        new.execute(params)
      end

      def initialize(validator = ::VkontakteApi)
        @validator = validator
      end

      def execute(params)
        fetch_user_data(params[:code], params[:redirect_uri]).then do |user_data|
          authenticate(user_id: user_data.user_id, email: user_data.email)
        end
      end

      private

      def fetch_user_data(code, redirect_uri)
        client = validator.authorize(code: code, redirect_uri: redirect_uri)

        raise Api::UnprocessableAuth, :email if invalid_token?(client)

        client
      rescue ::VkontakteApi::Error
        raise Api::UnprocessableAuth, :code
      end

      def invalid_token?(client)
        client.email.nil?
      end

      def provider
        :vk
      end
    end
  end
end
