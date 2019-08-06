# frozen_string_literal: true

module Users
  module Passwords
    # Users::Passwords::Change
    #
    #   Used to change user's password
    #
    class Change

      # (see #execute)
      def self.call(user, password_params)
        new.execute(user, password_params)
      end

      # Perform user password change
      #
      # @param user [User] -
      #   A user who performs reset their own password
      #
      # @param password_params [Hash] -
      #
      # @option params [String] :current_password -
      #   Current password that a user uses to log in
      #
      # @option params [String] :password -
      #   New user's password
      #
      # @option params [String] :password_confirmation -
      #   New user's password confirmation
      #
      # @raise [ActiveRecord::RecordInvalid] -
      #   Raises an error in the case of failed password validation
      #
      # @return [true, false] -
      #   Returns true in the case of successful password update
      #
      def execute(user, password_params)
        change_password(user, password_params).tap do |result|
          raise_validation_error(user) unless result
        end
      end

      private

      def change_password(user, params)
        user.update_with_password(params)
      end

      def raise_validation_error(user)
        raise ActiveRecord::RecordInvalid, user
      end
    end
  end
end
