# frozen_string_literal: true

# PaginationContract
#
#   Used to validate pagination params
#
class PaginationContract < Dry::Validation::Contract
  params do
    optional(:size)
      .type(:integer)
      .filled(:int?, lteq?: Paginatable::MAX_PAGE_SIZE, gteq?: Paginatable::MIN_PAGE_SIZE)

    optional(:number)
      .type(:integer)
      .filled(:int?, gteq?: 1)

    optional(:direction)
      .filled(:str?, included_in?: Paginatable::DIRECTIONS)

    optional(:last_id)
      .filled(:int?, gteq?: 0)

    optional(:field).filled(:str?)
    optional(:field_value).filled(:str?)
  end
end
