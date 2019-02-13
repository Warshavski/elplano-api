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

  has_many :created_events,
           class_name: 'Event',
           foreign_key: :creator_id,
           inverse_of: :creator,
           dependent: :delete_all

  validates :full_name, length: { maximum: 200 }
  validates :email,     length: { maximum: 100 }
  validates :phone,     length: { maximum: 50 }

  scope :presidents, -> { where(president: true) }

  def any_group?
    !supervised_group.nil? || !group.nil?
  end

  def group_owner?
    supervised_group&.president_id == id
  end
end
