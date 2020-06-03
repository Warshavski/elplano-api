# frozen_string_literal: true

# BugReportsFinder
#
#   Used to search, filter, and sort the collection of bugs reports
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class BugReportsFinder < ApplicationFinder
  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String, Symbol] :status
  #   One of the user status(banned, active, confirmed)
  #
  # @option params [Integer] :user_id
  #   Bug report reporter identity
  #
  def initialize(context: nil, params: {})
    super

    @context = BugReport.all
  end

  # Perform filtration and sort on bug reports list
  #
  # @note
  #  - by default all records are sorted by recently created
  #  - be default return records by chunks(15 records per chunk)
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    filter_by_user(context)
      .then(&method(:paginate))
      .then(&method(:sort))
  end

  private

  def filter_by_user(items)
    return items if filter_params[:user_id].blank?

    items.where(reporter_id: filter_params[:user_id])
  end
end
