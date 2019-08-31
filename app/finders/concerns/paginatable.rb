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
#
# @note Any previous sort options will be overwritten with defined in this concern.
#
module Paginatable
  COMPARATORS = { asc: '>', desc: '<' }.freeze

  DEFAULT_DIRECTION = 'desc'

  private_constant :COMPARATORS, :DEFAULT_DIRECTION

  # @param scope [ActiveRecord::Relation]
  #
  # @return [ActiveRecord::Relation]
  #
  def paginate(scope)
    scope = filter_by_field(scope)
    scope = filter_by_last_id(scope)

    scope = limit_items(scope)

    sort(scope)
  end

  private

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
    items.limit(params[:limit])
  end

  def sort(items)
    direction = params.fetch(:direction) { DEFAULT_DIRECTION }

    order_clause = params[:field] ? { params[:field] => direction } : {}

    items.reorder(order_clause.merge(id: direction))
  end
end
