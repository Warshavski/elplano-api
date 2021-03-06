# frozen_string_literal: true

module JsonApi
  # JsonApi::DoorkeeperConcern
  #
  #   Provides some JSON:API compatibility for Doorkeeper errors
  #
  module DoorkeeperConcern
    extend ActiveSupport::Concern

    included do
      protected

      def doorkeeper_unauthorized_render_options(error: nil) # rubocop:disable Lint/UnusedMethodArgument
        compose_doorkeeper_error(I18n.t(:'doorkeeper.errors.messages.invalid_token.unknown'), 401)
      end

      def doorkeeper_forbidden_render_options(error: nil) # rubocop:disable Lint/UnusedMethodArgument
        compose_doorkeeper_error(I18n.t(:'doorkeeper.errors.messages.access_denied'), 403)
      end

      private

      def compose_doorkeeper_error(message, status)
        error = {
          status: status,
          title: I18n.t('errors.messages.invalid_auth'),
          detail: message,
          source: {
            pointer: 'Authorization Header'
          }
        }

        { json: { errors: [error] } }
      end
    end
  end
end
