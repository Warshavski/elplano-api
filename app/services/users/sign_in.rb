# frozen_string_literal: true

module Users
  # Users::SignIn
  #
  #   Used to encapsulate authentication logic
  #     (user auth and token claim)
  #
  class SignIn

    # see #execute
    def self.call(&block)
      new.execute(&block)
    end

    # Perform authentication and access token claim
    #
    # @yield - custom auth logic such as call of warden auth methods
    #
    # @raise [ActiveRecord::RecordInvalid]
    # @return [User]
    #
    def execute
      yield.tap { |resource| claim_access_token!(resource) }
    end

    private

    def claim_access_token!(resource)
      params = {
        resource_owner_id: resource.id,
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
      }

      Doorkeeper::AccessToken.create!(params)
    end
  end
end
