# frozen_string_literal: true

module Audit
  module Events
    # Audit::Events::IndexContract
    #
    #   Used to validate filters for audit events list
    #
    class IndexContract < FilterContract
      params do
        optional(:type).filled(:str?, included_in?: AuditEvent.audit_types.keys)
      end
    end
  end
end
