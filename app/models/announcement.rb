# frozen_string_literal: true

# Announcement
#
#   Represents global application announcements
#
class Announcement < ApplicationRecord
  CACHE_KEY = 'announcements_current'

  validates :message, :start_at, :end_at, presence: true

  validates :foreground_color, :background_color, allow_nil: true, color: true

  after_commit :flush_cache

  class << self
    def current
      messages = cache.fetch(CACHE_KEY, expires_in: cache_expires_in) do
        current_and_upcoming
      end

      return [] if messages.blank?

      now_or_upcoming = messages.select(&:now_or_upcoming?)

      #
      # If there are cached entries but none are to be displayed we'll purge the
      # cache so we don't keep running this code all the time.
      #
      cache.delete(CACHE_KEY) if now_or_upcoming.empty?

      now_or_upcoming.select(&:now?)
    end

    def current_and_upcoming
      where('end_at > :now', now: Time.current).reorder(id: :asc)
    end

    def cache
      Rails.cache
    end

    def cache_expires_in
      2.weeks
    end
  end

  def active?
    started? && !ended?
  end

  def started?
    Time.current >= start_at
  end

  def ended?
    end_at < Time.current
  end

  def now?
    (start_at..end_at).cover?(Time.current)
  end

  def upcoming?
    start_at > Time.current
  end

  def now_or_upcoming?
    now? || upcoming?
  end

  def flush_cache
    self.class.cache.delete(CACHE_KEY)
  end
end
