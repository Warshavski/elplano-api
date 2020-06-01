# frozen_string_literal: true

# FilterContract
#
#   Used to common set of filter params
#
class FilterContract < Dry::Validation::Contract
  params do
    optional(:search).filled(:str?)
  end
end
