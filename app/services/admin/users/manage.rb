# frozen_string_literal: true

module Admin
  module Users
    # Admin::Users::Manage
    #
    #   Used to manage user state
    #
    class Manage
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
      #
      # @raise [ActiveRecord::RecordInvalid]
      #
      # @return [User]
      #
      def execute(user, action_type)
        user.tap { |u| self.class.actions[action_type.to_sym]&.call(u) }
      end
    end
  end
end
