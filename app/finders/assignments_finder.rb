# frozen_string_literal: true

# AssignmentsFinder
#
#   Used to search, filter, and sort the collection of course assignments.
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
# NOTE :
#
#   - by default returns assignments sorted by recently added.
#   - by default returns all assignments(outdated, active)
#   - by default returns assignments by chunks(15)
#
class AssignmentsFinder
  include Paginatable

  attr_reader :params, :student

  # @param student [Student]
  #   A student in the scope of which assignment filtration is performed
  #
  # @param params [Hash]
  #   Additional assignment filtration and sort parameters
  #
  # @option params [Integer] :course_id
  #   Assignment course identity
  #
  # @option params [Boolean] :outdated
  #   Outdated flag(true/false)
  #
  def initialize(student, params = {})
    @student = student
    @params = params
  end

  # Perform assignment filtration and sort
  #
  def execute
    collection = filter_by_course(student.assignments)
    collection = filter_by_expiration(collection)

    paginate(collection)
  end

  private

  def filter_by_course(items)
    params[:course_id].blank? ? items : items.where(course_id: params[:course_id])
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
      Assignment.none
    end
  end
end
