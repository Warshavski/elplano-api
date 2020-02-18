# frozen_string_literal: true

# AuditEvent
#
#   Used to represent any security-relevant occurrence in the system
#
class AuditEvent < ApplicationRecord
  enum audit_type: { authentication: 1, permanent_action: 2 }

  belongs_to :author,
             class_name: 'User',
             foreign_key: :author_id,
             inverse_of: :audit_events

  belongs_to :entity, polymorphic: true

  validates :author_id, :entity_id, :entity_type, presence: true

  scope :by_type, ->(type) { where(audit_type: audit_types[type]) }
end
