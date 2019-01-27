# frozen_string_literal: true

# GroupSerializer
#
#   Used for the group of students data representation
#
class GroupSerializer
  include FastJsonapi::ObjectSerializer

  attributes :number, :title, :created_at, :updated_at

  has_many :students, serializer: StudentSerializer
end
