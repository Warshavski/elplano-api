# frozen_string_literal: true

# CourseSerializer
#
#   [DESCRIPTION]
#
class CourseSerializer
  include FastJsonapi::ObjectSerializer

  set_type :course

  attributes :created_at, :updated_at

  attribute :title do |object|
    object.title.titleize
  end

  has_many :lecturers, serializer: LecturerSerializer
end
