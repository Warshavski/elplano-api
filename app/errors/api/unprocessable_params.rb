# frozen_string_literal: true

module Api
  # Api::UnprocessableParams
  #
  #   Raised in the case of invalid controller parameters
  #     (failed contract validation)
  #
  class UnprocessableParams < StandardError
    attr_reader :validation_errors

    def initialize(validation_errors)
      super.tap { @validation_errors = validation_errors }
    end
  end
end

