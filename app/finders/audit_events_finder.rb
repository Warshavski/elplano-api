# frozen_string_literal: true

# AuditEventsFinder
#
#   Used to search, filter, and sort the collection of audit events
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class AuditEventsFinder < ApplicationFinder
  alias current_user context

  # @param context [User]
  #   User for which audit events are filtered
  #
  # @param params [Hash]
  #   Optional filtration and sort parameters
  #
  # @option params [String, Symbol] :type
  #   Audit event type(authentication, permanent_action)
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
    filter_by_type(current_user.audit_events)
      .then(&method(:paginate))
      .then(&method(:apply_sort))
  end

  private

  def filter_by_type(items)
    return items if params[:type].blank?

    items.where(audit_type: AuditEvent.audit_types[params[:type]])
  end
end
