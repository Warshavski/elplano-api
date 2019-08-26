# frozen_string_literal: true

# Student
#
#   Represents student
#
class Student < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  has_many :classmates,
           class_name: 'Student',
           through: :group,
           source: :students,
           inverse_of: :group

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

  has_many :invitations,
           class_name: 'Invite',
           foreign_key: :recipient_id,
           inverse_of: :recipient,
           dependent: :destroy

  has_many :sent_invites,
           class_name: 'Invite',
           foreign_key: :sender_id,
           inverse_of: :sender,
           dependent: :destroy

  has_many :events, as: :eventable, dependent: :destroy

  validates :full_name, length: { maximum: 200 }
  validates :email,     length: { maximum: 100 }
  validates :phone,     length: { maximum: 50 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :presidents, -> { where(president: true) }

  def any_group?
    !supervised_group.nil? || !group.nil?
  end

  def group_owner?
    supervised_group&.president_id == id
  end
end
