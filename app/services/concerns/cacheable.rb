# frozen_string_literal: true

# Cacheable
#
#   Additions to provide result caching
#
module Cacheable
  extend ActiveSupport::Concern

  included do
    class << self
      def cache_options(options)
        @cache_key          = options[:key]
        @expires_in         = options[:expires_in] || 5.minutes
        @race_condition_ttl = options[:race_condition_ttl] || 5.seconds
      end

      # Execute command and cache it's results
      #
      def cached_call(*args)
        options = {
          race_condition_ttl: race_condition_ttl,
          expires_in: expires_in
        }

        cache_provider.fetch(cache_key, options) { call(*args) }
      end

      # Clear cache
      #
      def flush_cache
        cache_provider.delete(cache_key)
      end

      private

      attr_reader :cache_key, :expires_in, :race_condition_ttl

      def cache_provider
        Rails.cache
      end
    end
  end
end
