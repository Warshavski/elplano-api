# frozen_string_literal: true

# LabelsFinder
#
#   Used to search, filter, and sort the collection of student's labels
#     (created by student)
#
# Arguments:
#
#   params: optional search, filter and sort parameters
#
class LabelsFinder < Finder
  attr_reader :owner, :params

  # @param group [Group] -
  #   Owner of the searchable labels
  #
  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String] :search -
  #   Search pattern to search for(title, description part)
  #
  def initialize(group, params = {})
    @owner = group
    @params = params
  end

  # Perform filtration and sort on users list
  #
  # @note by default all records are sorted by recently created
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    perform_filtration.then(&method(:paginate))
  end

  private

  def perform_filtration
    owner.labels.then(&method(:perform_search))
  end

  def perform_search(items)
    params[:search].blank? ? items : items.search(params[:search])
  end
end
