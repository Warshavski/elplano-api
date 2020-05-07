# frozen_string_literal: true

module Admin
  module Users
    # Admin::Users::Manage
    #
    #   Used to manage user state
    #
    class Manage
      include Loggable

      class << self
        attr_reader :actions

        def action(type, &block)
          (@actions ||= {})[type] = block
        end

        # see #execute
        def call(current_user, user, action_type, **opts)
          new.execute(current_user, user, action_type, opts)
        end
      end

      action(:ban) do |user|
        user.tap { |u| u.update!(banned_at: Time.current) }
      end

      action(:unban) do |user|
        user.tap { |u| u.update!(banned_at: nil) }
      end

      action(:unlock) { |user| user.tap(&:unlock_access!) }

      action(:confirm) { |user| user.tap(&:confirm) }

      action(:logout) do |user|
        user.tap { |u| Doorkeeper::AccessToken.revoke_all_for(nil, u) }
      end

      action(:reset_password) do |user, params|
        user.password = params[:password]
        user.password_confirmation = params[:password_confirmation]

        user.tap(&:save!)
      end

      # TODO : add current user for logger and permissions check?
      #
      # Perform action execution
      #
      # @param user [User] -
      #   The user on whom one of the actions is performed.
      #
      # @param action_type [Symbol, String] -
      #   One of the followed actions type:
      #
      #     - ban - block access to the application
      #     - unban - remove application access block
      #     - unlock - remove lock caused by wrong password input
      #     - confirm - confirm user account
      #     - logout - perform user's access tokens revocation
      #     - reset_password - perform user's password reset
      #
      # @raise [ActiveRecord::RecordInvalid]
      #
      # @return [User]
      #
      def execute(current_user, user, action_type, **opts)
        action = self.class.actions[action_type.to_sym]

        user if action.nil?

        message =
          "User - \"#{user.username}\" (#{user.email}) was \"#{action_type}\" " \
          " by \"#{current_user.username}\" (#{current_user.email})"

        ApplicationRecord.transaction do
          action.call(user, opts).tap { log_info(message) }
        end
      end
    end
  end
end
