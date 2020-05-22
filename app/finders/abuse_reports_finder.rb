# frozen_string_literal: true

# AbuseReportsFinder
#
#   Used to search, filter, and sort the collection of abuses reports
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class AbuseReportsFinder < ApplicationFinder
  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String, Symbol] :reporter_id
  #   Abuse report reporter identity
  #
  # @option params [Integer] :user_id
  #   Abuser identity
  #
  def initialize(context: nil, params: {})
    super
  end

  # Perform filtration and sort on abuse reports list
  #
  # @note
  #  - by default all records are sorted by recently created
  #  - be default return records by chunks(15 records per chunk)
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    perform_filtration(AbuseReport).then(&method(:paginate))
  end

  private

  def perform_filtration(collection)
    collection
      .then { |ar| filter_by(:user_id, ar) }
      .then { |ar| filter_by(:reporter_id, ar) }
  end

  def filter_by(key, items)
    return items if params[key].blank?

    items.where(key => params[key])
  end
end
