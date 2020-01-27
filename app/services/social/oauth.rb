# frozen_string_literal: true

module Social
  # Social::Oauth
  #
  #   Used as base class for all oauth provides
  #
  class Oauth
    attr_reader :oauth_client, :authenticated_user

    # @see #execute
    #
    def self.call(params, user: nil)
      new(user: user).execute(params)
    end

    # @param oauth_client - client used to perform all requests
    # @param user - authenticated user to link provider to
    #
    def initialize(oauth_client = OAuth2::Client, user: nil)
      @authenticated_user = user
      @oauth_client = configure_oauth_client(oauth_client)
    end

    # Perform login via OAuth provider
    #
    # @param params [Hash]
    #   params required to perform login(such as code and redirect_uri)
    #
    # @option params [String] :code -
    #   The parameter received from the Login Dialog redirect above.
    #
    # @option params [String] :request_uri -
    #   This argument is required and must be the same as the original request_uri that
    #     you used when starting the OAuth login process.
    #
    # @return [Identity]
    #
    def execute(params)
      fetch_user_data(params[:code], params[:redirect_uri]).then(&method(:authenticate))
    end

    private

    def configure_oauth_client(_oauth_client)
      raise NotImplementedError
    end

    def fetch_user_data(code, redirect_uri)
      request_access_token!(code, redirect_uri).then(&method(:request_user_info!))
    rescue OAuth2::Error
      raise Api::UnprocessableAuth, :code
    end

    def request_access_token!(code, redirect_uri)
      oauth_client.auth_code.get_token(code, redirect_uri: redirect_uri).tap do |access_token|
        raise Api::UnprocessableAuth, :token if access_token.token.nil?
      end
    end

    def request_user_info!(_token)
      raise NotImplementedError
    end

    def authenticate(user_params)
      find_identity(user_params[:user_id]) || perform_registration(user_params)
    end

    def perform_registration(user_params)
      User.transaction do
        find_or_register_user(user_params[:email]).then do |user|
          user.identities.public_send(provider).create!(uid: user_params[:user_id])
        end
      end
    end

    def find_identity(user_id)
      Identity.public_send(provider).find_by(uid: user_id)
    end

    def find_or_register_user(email)
      user = authenticated_user || User.by_login(email)

      return user unless user.nil?

      params = {
        email: email,
        username: email
      }

      ::Users::Register.call do
        User.new(params.merge(password: temp_password), &:skip_confirmation!)
      end
    end

    def temp_password
      SecureRandom.hex(10)
    end

    def provider
      raise NotImplementedError
    end
  end
end
