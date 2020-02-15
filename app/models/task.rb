# frozen_string_literal: true

# Task
#
#   Represents event task(homework) for students in a group which the event is belongs to
#
class Task < ApplicationRecord
  belongs_to :author, class_name: 'Student',
                      foreign_key: :author_id,
                      inverse_of: :authored_tasks

  belongs_to :event

  has_many :appointments, class_name: 'Assignment',
                          inverse_of: :task,
                          dependent: :delete_all

  has_many :students, through: :appointments

  has_many :attachments, as: :attachable, dependent: :destroy

  scope :outdated,  -> { where(arel_table[:expired_at].lt(Time.current)) }
  scope :active,    -> { where(arel_table[:expired_at].gt(Time.current)).or(where(expired_at: nil)) }

  validates :title, presence: true

  validates :expired_at,
            allow_nil: true,
            timeliness: { after: -> { Time.current } }

  def outdated?
    expired_at.nil? ? false : (expired_at < Time.current)
  end
end
