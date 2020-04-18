# frozen_string_literal: true

module Announcements
  # Announcements::Cache
  #
  #   Used to manage cached announcements
  #
  class Cache
    CACHE_KEY = 'announcements_current'

    class << self
      def current
        messages = cache.fetch(CACHE_KEY, expires_in: cache_expires_in) do
          Announcement.current_and_upcoming
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

      def cache
        Rails.cache
      end

      def cache_expires_in
        2.weeks
      end

      def flush
        cache.delete(CACHE_KEY)
      end
    end
  end
end
