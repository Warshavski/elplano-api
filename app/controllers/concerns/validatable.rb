# frozen_string_literal: true

# Validatable
#
#   Used to provide validations for the controller's params via Dry Validation contracts
#
module Validatable
  extend ActiveSupport::Concern

  # Serializer
  #
  #   Used to serialize validation error in JSON:API format
  #
  # TODO : add localization
  #
  class Serializer
    def serialize(errors)
      errors.each_with_object([]) do |(attribute, messages), result|
        messages.each do |error_message|
          result << compose_error(attribute, 400, error_message)
        end
      end
    end

    def compose_error(attribute, status, message)
      {
        status: status,
        source: { pointer: attribute },
        detail: message
      }
    end
  end

  included do
    rescue_from Api::UnprocessableParams do |ex|
      handle_error(ex, :bad_request) do
        Serializer.new.serialize(ex.validation_errors.to_h)
      end
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
