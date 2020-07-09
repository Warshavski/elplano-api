# frozen_string_literal: true

module Users
  module Status
    # Users::Status::Upsert
    #
    #   Used to create/update or remove user status
    #
    class Manage
      class << self
        attr_reader :actions

        def action(type, &block)
          (@actions ||= {})[type] = block
        end

        # see #execute
        def call(action, user, opts = {})
          new(action, user, opts).execute
        end
      end

      action :upsert do |user, params|
        status = user.status

        if status.nil?
          user.create_status!(params)
        else
          status.tap { |s| s.update!(params) }
        end
      end

      action :destroy do |user|
        user.status&.destroy!
      end

      # @param action_type [String, Symbol]
      #   Action which should be performed against user status
      #
      # @param user [User]
      #   A user which status should be created/updated or deleted
      #
      # @param opts [Hash] (optional) additional arguments
      #
      def initialize(action_type, user, opts = {})
        @action_type = action_type.to_sym

        @user = user
        @options = opts
      end

      def execute
        action = self.class.actions[@action_type]

        action.call(@user, @options)
      end
    end
  end
end
