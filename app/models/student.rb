# frozen_string_literal: true

# Student
#
#   Represents student
#
class Student < ApplicationRecord
  include Searchable

  enum gender: { female: 0, male: 1, other: 2 }

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

  has_many :courses, through: :group

  has_many :authored_tasks,
           class_name: 'Task',
           foreign_key: :author_id,
           inverse_of: :author,
           dependent: :destroy

  has_many :assignments, dependent: :delete_all

  has_many :appointed_tasks, through: :assignments, source: :task

  attribute :social_networks, SocialNetwork.to_array_type

  validates :social_networks, store_model: { merge_errors: true }, allow_nil: true

  validates :full_name, length: { maximum: 200 }
  validates :email,     length: { maximum: 100 }
  validates :phone,     length: { maximum: 50 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :birthday,
            timeliness: { before: -> { Time.current }, allow_nil: true }

  scope :presidents, -> { where(president: true) }

  class << self
    # Search students with the given query
    #
    # @param query [String] - The search query as a String
    #
    # @note This method uses ILIKE on PostgreSQL
    #
    # @return [ActiveRecord::Relation]
    #
    def search(query)
      fuzzy_search(query, %i[full_name email phone])
    end
  end

  def any_group?
    !supervised_group.nil? || !group.nil?
  end

  def group_owner?
    supervised_group&.president_id == id
  end
end
