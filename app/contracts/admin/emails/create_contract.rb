# frozen_string_literal: true

module Admin
  module Emails
    # Admin::Emails::CreateContract
    #
    #   Used to validate user mailing params in admin section
    #
    class CreateContract < Dry::Validation::Contract
      params do
        required(:user_id).filled
        required(:type).filled(:str?, included_in?: User::MAILING_TYPES)
      end
    end
  end
end
