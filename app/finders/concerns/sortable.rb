# frozen_string_literal: true

# Sortable
#
#   Provides sorting logic to the finder.
#
# Sorting for resource attributes comes 'from the box', no additional configuration needed
#
# To specify a custom sorting:
#
#   class UsersFinder
#     include Sortable
#
#     specify_sort :name do |scope, direction|
#       scope.order(name: direction, id: :desc)
#     end
#   end
#
# To specify a default sorting:
#
#   class UsersFinder
#     include Sortable
#
#     specify_default_sort [{ id: :desc }, { name: :asc }]
#   end
#
# The sorting block will be called once for each sort attribute/direction requested.
#
# Sort parameters should be provided via: ':sort' key in finder parameters and
# presented by a string like: '-name,id'
#
module Sortable
  extend ActiveSupport::Concern

  SORT_PARAMETERS_SEPARATOR = ','
  DESC_SIGN = '-'

  private_constant :SORT_PARAMETERS_SEPARATOR

  class_methods do
    def specify_default_sort(parameters = nil)
      @default_sort = Array.wrap(parameters)
    end

    def specify_sort(trigger, &block)
      (@custom_sorts ||= {})[trigger] = block
    end

    def default_sort
      @default_sort || [{ id: :desc }]
    end

    def custom_sorts
      @custom_sorts || {}
    end
  end

  private

  def apply_sort(items)
    each_sort do |attribute, direction|
      next unless supported_attribute?(items, attribute)

      items = perform_sort(items, attribute, direction)
    end

    items
  end

  def each_sort
    sort_parameters.each do |sort_hash|
      attribute, direction = sort_hash.flatten

      yield attribute, direction
    end
  end

  def sort_parameters
    @sort_parameters ||= begin
                      if params[:sort].blank?
                        self.class.default_sort
                      else
                        normalize_parameters(params[:sort])
                      end
                    end
  end

  def normalize_parameters(raw_sort_parameters)
    return raw_sort_parameters if raw_sort_parameters.is_a?(Array)

    raw_sort_parameters
      .split(SORT_PARAMETERS_SEPARATOR)
      .map { |parameter| transform_parameter(parameter) }
  end

  def transform_parameter(parameter)
    direction = parameter[0] == DESC_SIGN ? :desc : :asc
    attribute = parameter.sub(DESC_SIGN, '').to_sym

    { attribute => direction }
  end

  def supported_attribute?(items, attribute)
    items.klass.column_names.include? attribute.to_s
  end

  def perform_sort(scope, attribute, direction)
    sort = self.class.custom_sorts[attribute]

    if sort.is_a? Proc
      sort.call(scope, direction)
    else
      scope.order(attribute => direction)
    end
  end
end
