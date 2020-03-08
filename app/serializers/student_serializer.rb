# frozen_string_literal: true.

# StudentSerializer
#
#   Used for the student data representation in scope of current user
#
class StudentSerializer < ApplicationSerializer
  set_type :student

  attributes :full_name, :email, :phone, :birthday, :gender,
             :about, :social_networks, :president, :created_at, :updated_at

  belongs_to :group,  serializer: GroupSerializer
  belongs_to :user,   serializer: UserSerializer
end
