# frozen_string_literal: true

# AuditEventSerializer
#
#   Used for audit event data representation
#
class AuditEventSerializer < ApplicationSerializer
  set_type :audit_event

  attributes :audit_type, :details, :created_at, :updated_at
end
