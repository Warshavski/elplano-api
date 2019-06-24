# frozen_string_literal: true

# UsersFinder
#
#   Used to search, filter, and sort the collection of users
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class UsersFinder
  attr_reader :params

  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String, Symbol] :status -
  #   One of the user status(banned, active, confirmed)
  #
  # @option params [String] :search -
  #   Search pattern to search for
  #
  def initialize(params = {})
    @params = params
  end

  # Perform filtration and sort on users list
  #
  # @note by default all records are sorted by recently created
  #
  def execute
    collection = User

    collection = filter_by_status(collection)
    collection = perform_search(collection)

    sort(collection)
  end

  private

  def filter_by_status(items)
    params[:status].blank? ? items : items.filter(params[:status])
  end

  def perform_search(items)
    params[:search].blank? ? items : items.search(params[:search])
  end

  def sort(items)
    params[:sort].blank? ? items.reorder(id: :desc) : items.order_by(params[:sort])
  end
end
