# frozen_string_literal: true

# ActivityEventSerializer
#
#   Used for activity event data representation
#
class ActivityEventSerializer < ApplicationSerializer
  set_type :activity_event

  attributes :action, :details, :created_at, :updated_at

  belongs_to :target, polymorphic: true
end
