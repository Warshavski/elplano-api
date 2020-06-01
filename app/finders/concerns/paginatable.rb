# frozen_string_literal: true

# Paginatable
#
#   Used to apply paginate filters
#
# Arguments :
#
#   @params scope [ActiveRecord::Relation]- Scope on which pagination is performed
#   @params params [Hash] - Pagination filter and sort options
#
#     @option params [Integer]  :last_id      - Identity of the last record in previous chunk
#     @option params [String]   :direction    - Records sort direction(asc - ascending, desc - descending)
#     @option params [String]   :field        - Name of the sortable field
#     @option params [String]   :field_value  - Value of the sortable field
#     @option params [Integer]  :size         - Quantity of the records in requested chuck
#     @option params [Integer]  :number       - Page number for page based pagination
#
# @note
#
#   - Any previous sort options will be overwritten with defined in this concern.
#   - By default returns records limited by 15.
#   - By default returns records sorted by recently created.
#
# TODO : rethink the idea of cursor-based pagination
#
module Paginatable
  COMPARATORS = { asc: '>', desc: '<' }.freeze

  DEFAULT_DIRECTION = 'desc'
  DEFAULT_PAGE_SIZE = 15
  DEFAULT_PAGE_NUMBER = 1

  DIRECTIONS = %w[asc desc].freeze

  MAX_PAGE_SIZE = 100
  MIN_PAGE_SIZE = 1

  private_constant :COMPARATORS, :DEFAULT_DIRECTION

  # @param scope [ActiveRecord::Relation<ApplicationRecord>]
  #
  # @return [ActiveRecord::Relation<ApplicationRecord>]
  #
  def paginate(scope)
    if pagination_params[:number].blank?
      perform_cursor_pagination(scope)
    else
      perform_default_pagination(scope)
    end
  end

  private

  def perform_default_pagination(scope)
    return items if pagination_params[:number].blank?

    scope.page(pagination_params[:number]).per(pagination_params[:size] || DEFAULT_PAGE_SIZE)
  end

  def perform_cursor_pagination(scope)
    scope
      .then(&method(:filter_by_field))
      .then(&method(:filter_by_last_id))
      .then(&method(:limit_items))
      .then(&method(:sort))
  end

  def filter_by_field(items)
    if pagination_params[:field] && pagination_params[:field_value]
      apply_filter(
        items,
        pagination_params[:field],
        pagination_params[:direction],
        pagination_params[:field_value]
      )
    else
      items
    end
  end

  def filter_by_last_id(items)
    return items unless pagination_params[:last_id]

    apply_filter(items, 'id', pagination_params[:direction], pagination_params[:last_id], '')
  end

  def apply_filter(scope, field, direction, field_value, quality_comparer = '=')
    comparer    = resolve_comparer(direction.to_sym, quality_comparer)
    field_name  = resolve_field_name(field, scope.table_name)

    scope.where("#{field_name} #{comparer} ?", field_value)
  end

  def resolve_comparer(direction, quality)
    "#{COMPARATORS[direction]}#{quality}"
  end

  def resolve_field_name(field, table_name)
    field.include?('.') ? field : (table_name + ".#{field}")
  end

  def limit_items(items)
    items.limit(pagination_params.fetch(:size) { DEFAULT_PAGE_SIZE })
  end

  def sort(items)
    direction = pagination_params.fetch(:direction) { DEFAULT_DIRECTION }

    order_clause = pagination_params[:field] ? { pagination_params[:field] => direction } : {}

    items.reorder(order_clause.merge(id: direction))
  end
end
