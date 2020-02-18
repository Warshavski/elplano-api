# frozen_string_literal: true

module Users
  # Users::SignIn
  #
  #   Used to encapsulate authentication logic
  #     (user auth and token claim)
  #
  class SignIn
    # see #execute
    def self.call(details, &block)
      new.execute(details, &block)
    end

    attr_reader :audit_logger

    def initialize(audit_logger = AuditEvents::Log)
      @audit_logger = audit_logger
    end

    # Perform authentication and access token claim
    #
    # @yield - custom auth logic such as call of warden auth methods
    #
    # @raise [ActiveRecord::RecordInvalid]
    # @return [User]
    #
    def execute(details = {})
      yield.tap do |resource|
        claim_access_token!(resource).then { |token| log_audit_event(token, details) }
      end
    end

    private

    def claim_access_token!(resource)
      params = {
        resource_owner_id: resource.id,
        expires_in: Doorkeeper.configuration.access_token_expires_in,
        use_refresh_token: Doorkeeper.configuration.refresh_token_enabled?
      }

      AccessToken.create!(params)
    end

    def log_audit_event(token, details)
      audit_logger.call(:authentication, token.owner, token.owner, details)
    end
  end
end
