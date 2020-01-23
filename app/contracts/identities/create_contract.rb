# frozen_string_literal: true

module Identities
  # Identities::CreateContract
  #
  #   Used to validate params for social login action
  #
  class CreateContract < Dry::Validation::Contract
    params do
      required(:redirect_uri).filled(:str?)
      required(:code).filled(:str?)
      required(:provider).filled(:str?, included_in?: Identity.providers.keys)
    end
  end
end
