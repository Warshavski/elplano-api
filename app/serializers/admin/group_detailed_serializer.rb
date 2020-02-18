# frozen_string_literal: true

module Admin
  # Admin::GroupDetailedSerializer
  #
  #   Used for the group of students data representation
  #     ("show" data)
  #
  class GroupDetailedSerializer < GroupCoreSerializer
    set_type :group

    has_many :students, serializer: StudentSerializer
  end
end
