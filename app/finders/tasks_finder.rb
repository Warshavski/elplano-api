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
class TasksFinder < Finder

  attr_reader :params, :current_student

  # @param current_student [Student]
  #   A student in the scope of which task filtration is performed
  #
  # @param params [Hash]
  #   Additional task filtration and sort parameters
  #
  # @option params [Integer] :event_id
  #   Task event identity
  #
  # @option params [Boolean] :outdated
  #   Outdated flag(true/false)
  #
  # @option params [Boolean] :accomplished
  #   Accomplished flag(true/false)
  #
  # @option params [Boolean] :appointed
  #   Appointed flag(true/false) if task was appointed to student
  #
  # @note - accomplishment filtration can be applied in the scope of appointed tasks
  #
  def initialize(current_student, params = {})
    @current_student = current_student
    @params = params
  end

  # Perform task filtration and sort
  #
  def execute
    resolve_scope
      .then(&method(:perform_filtration))
      .then(&method(:paginate))
  end

  private

  def resolve_scope
    if params[:appointed].present? || !params[:accomplished].nil?
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
    params[:event_id].blank? ? items : items.where(event_id: params[:event_id])
  end

  def filter_by_expiration(items)
    case params[:outdated]
    when nil
      items
    when true
      items.outdated
    when false
      items.active
    else
      Task.none
    end
  end

  def filter_by_accomplishment(items)
    case params[:accomplished]
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
