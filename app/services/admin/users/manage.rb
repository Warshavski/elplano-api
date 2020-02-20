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
        def call(user, action_type)
          new.execute(user, action_type)
        end
      end

      action(:ban) { |user| user.update!(banned_at: Time.current) }

      action(:unban) { |user| user.update!(banned_at: nil) }

      action(:unlock) { |user| user.unlock_access! }

      action(:confirm) { |user| user.confirm }

      action(:logout) do |user|
        Doorkeeper::AccessToken.revoke_all_for(nil, user)
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
      #
      # @raise [ActiveRecord::RecordInvalid]
      #
      # @return [User]
      #
      def execute(user, action_type)
        user.tap do |u|
          action = self.class.actions[action_type.to_sym]

          if action
            action.call(u)
            log_info("User - \"#{u.username}\" (#{u.email}) was \"#{action_type}\"")
          end
        end
      end
    end
  end
end
