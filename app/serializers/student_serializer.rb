# frozen_string_literal: true.

# StudentSerializer
#
#   Used for the student data representation in scope of current user
#
class StudentSerializer
  include FastJsonapi::ObjectSerializer

  attributes :full_name, :email, :phone,
             :about, :social_networks, :president,
             :created_at, :updated_at

  belongs_to :group, serializer: GroupSerializer
end
