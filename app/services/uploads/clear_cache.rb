# frozen_string_literal: true

module Uploads
  # Uploads::ClearCache
  #
  #   Used to clean-up uploads cache storage
  #
  class ClearCache
    include Loggable

    # @see #execute
    def self.call
      new.execute
    end

    # Perform uploads cache storage clean-up
    #
    def execute
      Shrine.storages[:cache].clear! do |object|
        Rails.env.production? ? s3_check(object) : filesystem_check(object)
      end

      log_info('System - Uploads cache storage was cleared')
    end

    private

    def s3_check(object)
      object.last_modified < resolve_threshold
    end

    def filesystem_check(object)
      object.mtime < resolve_threshold
    end

    def resolve_threshold
      Time.now.utc - 1.day
    end
  end
end
