# frozen_string_literal: true

module Users
  # Users::DestroyContract
  #
  #   Used to validate params for user destroy action
  #
  class DestroyContract < Dry::Validation::Contract
    params do
      required(:password).value(:string)
    end
  end
end
