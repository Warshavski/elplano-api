# frozen_string_literal: true

# DoorkeeperJsonApi
#
#   Provides some JSON:API compatibility for Doorkeeper errors
#
module DoorkeeperJsonApi
  extend ActiveSupport::Concern

  included do
    protected

    def doorkeeper_unauthorized_render_options(error: nil)
      compose_doorkeeper_error(I18n.t(:'doorkeeper.errors.messages.invalid_token.unknown'), 401)
    end

    def doorkeeper_forbidden_render_options(error: nil)
      compose_doorkeeper_error(I18n.t(:'doorkeeper.errors.messages.access_denied'), 403)
    end

    private

    def compose_doorkeeper_error(message, status)
      {
        json: {
          errors: [
            {
              status: status,
              title: I18n.t('errors.messages.invalid_auth'),
              detail: message,
              source: {
                pointer: 'Authorization Header'
              }
            }
          ]
        }
      }
    end
  end
end
