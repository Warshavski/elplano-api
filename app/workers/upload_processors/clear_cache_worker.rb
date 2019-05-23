# frozen_string_literal: true

module UploadProcessors
  # UploadProcessors::ClearCacheWorker
  #
  #   [DESCRIPTION]
  #
  class ClearCacheWorker
    include Sidekiq::Worker

    def perform
      cache_storage = Shrine.storages[:cache]
      cache_storage.clear! { |object| object.last_modified < Time.utc.now - 1.day }
    end
  end
end
