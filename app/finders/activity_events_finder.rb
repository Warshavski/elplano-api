# frozen_string_literal: true

# ActivityEventsFinder
#
#   Used to search, filter, and sort the collection of activity events
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class ActivityEventsFinder < ApplicationFinder
  alias current_user context

  # @param context [User]
  #   (optional, default: nil) User for which activity events are filtered
  #
  # @param params [Hash]
  #   (optional, default: {}) Optional filtration and sort parameters
  #
  # @option params [String, Symbol] :action
  #   Activity event action(created, updated)
  #
  # @option params [Integer] :author_id
  #   Activity event author
  #
  def initialize(context: nil, params: {})
    super
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
    resolve_scope
      .then(&method(:filter_by_action))
      .then(&method(:filter_by_author))
      .then(&method(:paginate))
  end

  private

  def resolve_scope
    current_user&.activity_events || ActivityEvent.all
  end

  def filter_by_action(items)
    params[:action].blank? ? items : items.by_action(params[:action])
  end

  def filter_by_author(items)
    params[:author_id].blank? ? items : items.where(author_id: params[:author_id])
  end
end
