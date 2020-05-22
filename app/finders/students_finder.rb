# frozen_string_literal: true

# StudentsFinder
#
#   Used to search, filter, and sort the collection of students
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class StudentsFinder < ApplicationFinder
  alias current_group context

  # @param context [Group] -
  #  A group in the scope of which filtration is performed
  #
  # @param params [Hash] -
  #   (optional, default: {}) filter and sort parameters
  #
  # @option params [String] :search -
  #   Search pattern to search for
  #
  def initialize(context:, params: {})
    super
  end

  # Perform filtration and sort on students list
  #
  # @note by default all records are sorted by recently created
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    init_collection.then(&method(:perform_search))
  end

  private

  def init_collection
    current_group.students.order(id: :desc)
  end

  def perform_search(items)
    params[:search].blank? ? items : items.search(params[:search])
  end
end
