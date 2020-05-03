# frozen_string_literal: true

module Admin
  # Admin::PasswordContract
  #
  #   Used to validate password params
  #
  class PasswordContract < Dry::Validation::Contract
    params do
      required(:password).value(:string)
      required(:password_confirmation).value(:string)
    end
  end
end
