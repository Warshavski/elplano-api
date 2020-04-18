# frozen_string_literal: true

# Announcement
#
#   Represents global application announcements
#
class Announcement < ApplicationRecord
  scope :current_and_upcoming, lambda {
    where(arel_table[:end_at].gt(Time.current)).reorder(id: :asc)
  }

  validates :message, :start_at, :end_at, presence: true

  validates :foreground_color, :background_color, allow_nil: true, color: true

  after_commit -> { Announcements::Cache.flush }

  def now?
    (start_at..end_at).cover?(Time.current)
  end

  def upcoming?
    start_at > Time.current
  end

  def now_or_upcoming?
    now? || upcoming?
  end
end
