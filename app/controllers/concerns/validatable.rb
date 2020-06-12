# frozen_string_literal: true

# Validatable
#
#   Used to provide validations for the controller's params via Dry Validation contracts
#
module Validatable
  extend ActiveSupport::Concern

  # Validatable::Serializer
  #
  #   Used to serialize validation error in JSON:API format
  #
  # TODO : add localization
  #
  class Serializer
    def initialize(error, status_code)
      @error_messages = error.validation_errors.to_h
      @status_code = status_code
    end

    def serialize
      @error_messages.each_with_object([]) do |(attribute, messages), result|
        messages.each do |error_message|
          result << compose_error(attribute, @status_code, error_message)
        end
      end
    end

    def compose_error(attribute, status, message)
      {
        status: status,
        source: { parameter: attribute },
        detail: message
      }
    end
  end

  included do
    rescue_from Api::UnprocessableParams do |e|
      handle_error(e, :validation, status: :bad_request)
    end
  end

  def validate_with(contract, raw_params)
    params = normalize_params(raw_params)

    validation_result = contract.call(params).tap do |result|
      raise_error(result) unless result.success?
    end

    validation_result.to_h
  end

  private

  def normalize_params(raw_params)
    raw_params.is_a?(Hash) ? raw_params : raw_params&.to_unsafe_h
  end

  def raise_error(result)
    raise Api::UnprocessableParams, result.errors
  end
end
