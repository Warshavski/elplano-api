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
#     @option params [Integer]  :limit        - Quantity of the records in requested chuck
#     @option params [String]   :direction    - Records sort direction(asc - ascending, desc - descending)
#     @option params [String]   :field        - Name of the sortable field
#     @option params [String]   :field_value  - Value of the sortable field
#     @option params [Integer]  :page         - Page number for page based pagination
#
# @note
#
#   - Any previous sort options will be overwritten with defined in this concern.
#   - By default returns records limited by 15.
#   - By default returns records sorted by recently created.
#
module Paginatable
  COMPARATORS = { asc: '>', desc: '<' }.freeze

  DEFAULT_DIRECTION = 'desc'
  DEFAULT_LIMIT = 15

  DIRECTIONS = %w[asc desc].freeze

  MAX_LIMIT = 100
  MIN_LIMIT = 1

  private_constant :COMPARATORS,
                   :DEFAULT_DIRECTION, :DEFAULT_LIMIT

  # @param scope [ActiveRecord::Relation<ApplicationRecord>]
  #
  # @return [ActiveRecord::Relation<ApplicationRecord>]
  #
  def paginate(scope)
    scope = if params[:page].blank?
              perform_cursor_pagination(scope)
            else
              perform_default_pagination(scope)
            end

    sort(scope)
  end

  private

  def perform_default_pagination(scope)
    return items if params[:page].blank?

    scope.page(params[:page]).per(params[:limit] || DEFAULT_LIMIT)
  end

  def perform_cursor_pagination(scope)
    scope
      .then(&method(:filter_by_field))
      .then(&method(:filter_by_last_id))
      .then(&method(:limit_items))
  end

  def filter_by_field(items)
    if params[:field] && params[:field_value]
      apply_filter(items, params[:field], params[:direction], params[:field_value])
    else
      items
    end
  end

  def filter_by_last_id(items)
    return items unless params[:last_id]

    apply_filter(items, 'id', params[:direction], params[:last_id], '')
  end

  def apply_filter(scope, field, direction, field_value, eq = '=')
    comparer    = resolve_comparer(direction.to_sym, eq)
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
    items.limit(params.fetch(:limit) { DEFAULT_LIMIT })
  end

  def sort(items)
    direction = params.fetch(:direction) { DEFAULT_DIRECTION }

    order_clause = params[:field] ? { params[:field] => direction } : {}

    items.reorder(order_clause.merge(id: direction))
  end
end
