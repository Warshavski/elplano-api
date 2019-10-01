# frozen_string_literal: true

# AssignmentSerializer
#
#   Used for course assignment data representation
#
class AssignmentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :assignment

  attributes :title, :description,
             :expired_at, :created_at, :updated_at

  attribute :outdated, &:outdated?

  belongs_to :course, serializer: CourseSerializer
end
