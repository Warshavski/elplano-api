# frozen_string_literal: true

module Users
  module Tokens
    # User::Tokens::Clear
    #
    #   Used to clear revoked and expired access tokens and access grants
    #
    class Clear
      include Loggable

      DEFAULT_DAYS_BEFORE = 30
      TOKEN_MODELS = [Doorkeeper::AccessGrant, Doorkeeper::AccessToken].freeze

      private_constant :DEFAULT_DAYS_BEFORE, :TOKEN_MODELS

      # @see #execute
      def self.call(days)
        new.execute(days)
      end

      # Perform users token clean-up
      #
      # @param days [Integer]
      #    The number of days that will be used to determine the threshold date for the token deletion.
      #
      def execute(days = nil)
        expire_params = [compose_query, compose_condition(days)]

        TOKEN_MODELS.each do |klass|
          perform_delete(klass, expire_params)

          log_info("System - #{klass.model_name.human} was cleaned-up")
        end
      end

      private

      def compose_query
        <<~SQL.squish
          (revoked_at IS NOT NULL AND revoked_at < :delete_before) OR
          (expires_in IS NOT NULL AND (created_at + expires_in * INTERVAL '1 second') < :delete_before)
        SQL
      end

      def compose_condition(days)
        { delete_before: (days || DEFAULT_DAYS_BEFORE).to_i.days.ago }
      end

      def perform_delete(klass, params)
        klass.where(params).delete_all
      end
    end
  end
end
