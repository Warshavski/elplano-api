# frozen_string_literal: true

# CourseSerializer
#
#   Used for course data representation
#
class CourseSerializer < ApplicationSerializer
  set_type :course

  attributes :active, :created_at, :updated_at

  attribute :title do |object|
    object.title.titleize
  end

  has_many :lecturers, serializer: LecturerSerializer
end
