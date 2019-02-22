# frozen_string_literal: true.

# StudentSerializer
#
#   Used for the student data representation in scope of current user
#
class StudentSerializer
  include FastJsonapi::ObjectSerializer

  EXCLUDE_GROUP = proc do |_record, params|
    !params[:exclude]&.include?(:group)
  end

  set_type :student

  attributes :full_name, :email, :phone,
             :about, :social_networks, :president,
             :created_at, :updated_at

  belongs_to :group,  serializer: GroupSerializer, if: EXCLUDE_GROUP
  belongs_to :user,   serializer: UserSerializer
end
