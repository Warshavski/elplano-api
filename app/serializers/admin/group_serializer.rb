# frozen_string_literal: true

module Admin
  # Admin::GroupSerializer
  #
  #   Used for the group of students data representation
  #     (admin section)
  #
  class GroupSerializer < ::GroupSerializer
    set_type :group

    belongs_to :president,
               record_type: :student,
               serializer: StudentSerializer

    has_many :students,
             lazy_load_data: true,
             serializer: StudentSerializer
  end
end
