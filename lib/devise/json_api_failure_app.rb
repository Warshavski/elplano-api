# frozen_string_literal: true

module Devise
  # Devise::JsonApiFailureApp
  #
  #   Custom failure response app since we want to return JSON:API like message.
  #
  class JsonApiFailureApp < Devise::FailureApp
    def respond
      if api_request? || oauth_request?
        json_api_error_response
      else
        super
      end
    end

    private

    def api_request?
      request.controller_class.to_s.start_with? 'Api::'
    end

    def oauth_request?
      request.controller_class.to_s.start_with? 'Doorkeeper::'
    end

    def json_api_error_response
      self.status        = 401
      self.content_type  = 'application/vnd.api+json'
      self.response_body = { errors: [{ status: '401', detail: i18n_message }] }.to_json
    end
  end
end
