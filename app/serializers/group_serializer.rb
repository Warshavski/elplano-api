# frozen_string_literal: true

# GroupSerializer
#
#   Used for the group of students data representation
#
class GroupSerializer
  include FastJsonapi::ObjectSerializer

  EXCLUDE_STUDENTS = proc do |_record, params|
    !params[:exclude]&.include?(:students)
  end

  set_type :group

  attributes :number, :title, :created_at, :updated_at

  has_many :students,
           serializer: StudentSerializer,
           if: EXCLUDE_STUDENTS
end
