# frozen_string_literal: true

# Student
#
#   Represents student
#
class Student < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  has_one :supervised_group,
          class_name: 'Group',
          inverse_of: :president,
          foreign_key: :president_id,
          dependent: :destroy

  validates :full_name, length: { maximum: 200 }
  validates :email,     length: { maximum: 100 }
  validates :phone,     length: { maximum: 50 }

  scope :presidents, -> { where(president: true) }
end
