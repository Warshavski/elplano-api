# frozen_string_literal: true

module Admin
  # Admin::GroupCoreSerializer
  #
  #   Used for the group of students data representation
  #     ("index" data)
  #
  class GroupCoreSerializer < ::GroupSerializer
    set_type :group

    belongs_to :president,
               record_type: :student,
               serializer: StudentSerializer
  end
end
