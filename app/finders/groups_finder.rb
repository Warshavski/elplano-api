# frozen_string_literal: true

# GroupsFinder
#
#   Used to search, filter, and sort the collection of groups
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class GroupsFinder < ApplicationFinder
  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String] :search  Search pattern to search for
  #
  def initialize(context: nil, params: {})
    super
  end

  # Perform filtration and sort on groups list
  #
  # @note by default all records are sorted by recently created
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    perform_search(Group)
      .then(&method(:paginate))
      .then(&method(:apply_sort))
  end

  private

  def perform_search(items)
    filter_params[:search].blank? ? items : items.search(filter_params[:search])
  end
end
