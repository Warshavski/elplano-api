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
class LabelsFinder < ApplicationFinder
  alias owner context

  # @param context [Group] -
  #   (optional, default: nil) Owner of the searchable labels
  #
  # @param params [Hash] - (optional, default: {}) filter and sort parameters
  #
  # @option params [String] :search -
  #   Search pattern to search for(title, description part)
  #
  def initialize(context: nil, params: {})
    super
  end

  # Perform filtration and sort on users list
  #
  # @note by default all records are sorted by recently created
  #
  # @return [ActiveRecord::Relation]
  #
  def execute
    resolve_scope
      .then(&method(:perform_filtration))
      .then(&method(:paginate))
  end

  private

  def resolve_scope
    owner&.labels || Label.all
  end

  def perform_filtration(scope)
    params[:search].blank? ? scope : scope.search(params[:search])
  end
end
