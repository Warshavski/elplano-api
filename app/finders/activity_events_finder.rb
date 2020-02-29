# frozen_string_literal: true

# ActivityEventsFinder
#
#   Used to search, filter, and sort the collection of activity events
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class ActivityEventsFinder < Finder
  attr_reader :params, :current_user

  # @param user [User]
  #   User for which activity events are filtered
  #
  # @param params [Hash]
  #   Optional filtration and sort parameters
  #
  # @option params [String, Symbol] :action
  #   Activity event action(created, updated)
  #
  def initialize(user, params = {})
    @current_user = user
    @params = params
  end

  # Perform filtration and sort on list
  #
  # @note
  #  - by default all records are sorted by recently created
  #  - be default return records by chunks(15 records per chunk)
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    filter_by_action(current_user.activity_events).then(&method(:paginate))
  end

  private

  def filter_by_action(items)
    params[:action].blank? ? items : items.by_action(params[:action])
  end
end
