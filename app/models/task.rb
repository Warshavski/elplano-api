# frozen_string_literal: true

# Task
#
#   Represents event task(homework) for students in a group which the event is belongs to
#
class Task < ApplicationRecord
  EXPIRATION_SCOPES = %w[outdated active today tomorrow upcoming].freeze

  belongs_to :author, class_name: 'Student',
                      foreign_key: :author_id,
                      inverse_of: :authored_tasks

  belongs_to :event

  has_many :appointments, class_name: 'Assignment',
                          inverse_of: :task,
                          dependent: :delete_all

  has_many :students, through: :appointments

  has_many :attachments, as: :attachable, dependent: :destroy

  scope :outdated,  -> { where(arel_table[:expired_at].lt(Date.current)) }
  scope :active,    -> { where(arel_table[:expired_at].gteq(Date.current)).or(where(expired_at: nil)) }

  scope :today, -> { where(expired_at: Date.current) }
  scope :tomorrow, -> { where(expired_at: Date.current + 1.day) }
  scope :upcoming, -> { where(arel_table[:expired_at].gt(Date.current + 1.day)) }

  attribute :extra_links, ExtraLink.to_array_type

  validates :extra_links, store_model: { merge_errors: true }, allow_nil: true

  validates :title, presence: true

  validates :expired_at,
            allow_nil: true,
            timeliness: { on_or_after: -> { Date.current } }

  validate do
    errors.add(:students, :invalid_assignment) if assigned? && (!author.group_owner? && !self_assigned?)
  end

  def self_assigned?
    student_ids == [author.id]
  end

  def assigned?
    student_ids.present?
  end

  def outdated?
    expired_at.nil? ? false : (expired_at < Date.current)
  end
end
