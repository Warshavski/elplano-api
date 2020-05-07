# frozen_string_literal: true

# ActivityEvent
#
#   Represents user activity in application
#
class ActivityEvent < ApplicationRecord
  # TODO : populate actions
  enum action: {
    created: 1,
    updated: 2
  }

  # TODO : populate targets
  TARGETS = {
    invite: 'Invite',
    assignment: 'Assignment',
    user: 'User'
  }.freeze

  belongs_to :author,
             class_name: 'User',
             foreign_key: :author_id,
             inverse_of: :activity_events

  belongs_to :target, polymorphic: true

  validates :author_id, :target_id, :target_type, presence: true
  validates :target_type, inclusion: { in: TARGETS.values }

  scope :by_action, ->(action) { where(action: actions[action]) }
end
