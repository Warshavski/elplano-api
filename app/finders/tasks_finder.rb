# frozen_string_literal: true

# TasksFinder
#
#   Used to search, filter, and sort the collection of event tasks.
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
# NOTE :
#
#   - by default returns tasks sorted by recently added.
#   - by default returns all tasks(outdated, active)
#   - by default returns tasks by chunks(15)
#   - by default returns authored tasks(tasks created by current student)
#
class TasksFinder < ApplicationFinder
  alias current_student context

  # @param context [Student]
  #   A student in the scope of which task filtration is performed
  #
  # @param params [Hash]
  #   Additional task filtration and sort parameters
  #
  # @option params [Integer] :event_id
  #   Task event identity
  #
  # @option params [String] :expiration
  #   Filter by expiration scope(@see Task::EXPIRATION_SCOPES)
  #
  # @option params [Boolean] :accomplished
  #   Accomplished flag(true/false)
  #
  # @option params [Boolean] :appointed
  #   Appointed flag(true/false) if task was appointed to student
  #
  # @note - accomplishment filtration can be applied in the scope of appointed tasks
  #
  def initialize(context:, params: {})
    super
  end

  # Perform task filtration and sort
  #
  def execute
    resolve_scope
      .then(&method(:perform_filtration))
      .then(&method(:paginate))
      .then(&method(:apply_sort))
  end

  private

  def resolve_scope
    if filter_params[:appointed].present? || !filter_params[:accomplished].nil?
      current_student.appointed_tasks
    else
      current_student.authored_tasks
    end
  end

  def perform_filtration(collection)
    collection
      .then(&method(:filter_by_event))
      .then(&method(:filter_by_expiration))
      .then(&method(:filter_by_accomplishment))
  end

  def filter_by_event(items)
    filter_params[:event_id].blank? ? items : items.where(event_id: filter_params[:event_id])
  end

  def filter_by_expiration(items)
    expiration_scope = filter_params[:expiration].to_s

    return items if expiration_scope.blank?

    if expiration_scope.in? Task::EXPIRATION_SCOPES
      items.public_send(expiration_scope)
    else
      Task.none
    end
  end

  def filter_by_accomplishment(items)
    case filter_params[:accomplished]
    when nil
      items
    when false
      items.merge(Assignment.unfulfilled)
    when true
      items.merge(Assignment.accomplished)
    else
      Task.none
    end
  end
end
