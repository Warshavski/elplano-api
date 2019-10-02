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
  # @option params [Boolean] :accomplished
  #   Accomplished flag(true/false)
  #
  def initialize(student, params = {})
    @student = student
    @params = params
  end

  # Perform assignment filtration and sort
  #
  def execute
    collection = init_collection(student)

    collection = filter_by_course(collection)
    collection = filter_by_expiration(collection)
    collection = filter_by_accomplishment(collection)

    paginate(collection)
  end

  private

  def init_collection(student)
    scope = student.assignments

    attributes = [
      :id, :author_id, :course_id,
      :title, :description,
      :expired_at, :created_at, :updated_at,
      'accomplishments.id as accomplishment_id'
    ]

    # Anyway we need information if an assignment is accomplished or not
    scope.select(*attributes).left_joins(:accomplishments)
  end

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

  def filter_by_accomplishment(items)
    case params[:accomplished]
    when nil
      items
    when false
      items.merge(Accomplishment.where(id: nil))
    when true
      items.merge(Accomplishment.where.not(id: nil))
    else
      Assignment.none
    end
  end
end
