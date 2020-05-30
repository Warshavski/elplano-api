# frozen_string_literal: true

# UsersFinder
#
#   Used to search, filter, and sort the collection of users
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class UsersFinder < ApplicationFinder
  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String, Symbol] :status -
  #   One of the user status(banned, active, confirmed)
  #
  # @option params [String] :search -
  #   Search pattern to search for
  #
  def initialize(context: nil, params: {})
    super

    @context = User.all
  end

  # Perform filtration and sort on users list
  #
  # @note by default all records are sorted by recently created
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    perform_filtration
      .then(&method(:paginate))
      .then(&method(:apply_sort))
  end

  private

  def perform_filtration
    context
      .then(&method(:filter_by_status))
      .then(&method(:perform_search))
  end

  def filter_by_status(items)
    params[:status].blank? ? items : items.filter_by(params[:status])
  end

  def perform_search(items)
    params[:search].blank? ? items : items.search(params[:search])
  end
end
