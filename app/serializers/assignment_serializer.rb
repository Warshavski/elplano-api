# frozen_string_literal: true

# AssignmentSerializer
#
#   Used for task assignment data representation
#
class AssignmentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :assignment

  attributes :accomplished, :report, :extra_links, :created_at, :updated_at

  belongs_to :task, serializer: TaskSerializer
end
