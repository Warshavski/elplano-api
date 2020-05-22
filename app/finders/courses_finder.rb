# frozen_string_literal: true

# CoursesFinder
#
#   Used to search, filter, and sort the collection of group's courses
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
# NOTE :
#
#   - by default returns courser sorted by recently added.
#   - by default returns all courses(active and not active).
#   - by default returns paginated chunks(15 records per chunk)
#
class CoursesFinder < ApplicationFinder
  alias group context

  # @param context [Group]
  #   The group by which the filtration is performed
  #
  # @param params [Hash]
  #   (optional, default: {}) filter and sort parameters
  #
  # @option params [Boolean] :active -
  #   Availability flag(true, false)
  #
  def initialize(context: nil, params: {})
    super
  end

  # Perform filtration and sort on group's courses list
  #
  # @note by default returns all courses(active and not active),
  #   sorted by recently created
  #
  def execute
    return Course.none if group.nil?

    filter_by_availability(group.courses).then(&method(:paginate))
  end

  private

  def filter_by_availability(items)
    case params[:active]
    when nil
      items
    when true
      items.active
    when false
      items.deactivated
    else
      Course.none
    end
  end
end
