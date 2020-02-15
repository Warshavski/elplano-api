# frozen_string_literal: true

# CourseSerializer
#
#   Used for course data representation
#
class CourseSerializer
  include FastJsonapi::ObjectSerializer

  set_type :course

  attributes :active, :created_at, :updated_at

  attribute :title do |object|
    object.title.titleize
  end

  has_many :lecturers,
           lazy_load_data: true,
           serializer: LecturerSerializer
end
