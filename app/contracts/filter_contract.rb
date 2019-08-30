# frozen_string_literal: true

# PaginateContract
#
#   Used to validate pagination params
#
class FilterContract < Dry::Validation::Contract
  params do
    optional(:limit)
      .filled(:int?, lteq?: Paginatable::MAX_LIMIT, gteq?: Paginatable::MIN_LIMIT)

    optional(:direction)
      .filled(:str?, included_in?: Paginatable::DIRECTIONS)

    optional(:last_id)
      .filled(:int?, gteq?: 0)

    optional(:field).filled(:str?)
    optional(:field_value).filled(:str?)
    optional(:search).filled(:str?)
  end
end
