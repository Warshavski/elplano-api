# frozen_string_literal: true

module AuditEvents
  # AuditEvents::Log
  #
  #   Used to create and log audit events
  #
  class Log
    # see #execute
    def self.call(type, author, entity, details = {})
      new(author, entity, details).execute(type)
    end

    def initialize(author, entity, details = {})
      @author = author
      @entity = entity
      @details = details
    end

    def execute(type)
      compose_payload(type).then { |payload| AuditEvent.create(payload) }
    end

    private

    def compose_payload(type)
      payload_funcs = {
        authentication: -> { authentication_payload }
      }

      details = payload_funcs[type.to_sym].call

      basic_payload.merge(details: details, audit_type: type)
    end

    def authentication_payload
      {
        with: @details[:with],
        target_id: @author.id,
        target_type: 'User',
        target_details: @author.username
      }
    end

    def basic_payload
      {
        author_id: @author.id,
        entity_id: @entity.id,
        entity_type: @entity.class.name
      }
    end
  end
end
