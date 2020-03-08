# frozen_string_literal: true

# AnnouncementSerializer
#
#   Used for application announcement data representation
#
class AnnouncementSerializer < ApplicationSerializer
  set_type :announcement

  attributes :message, :background_color, :foreground_color,
             :start_at, :end_at, :created_at, :updated_at
end
