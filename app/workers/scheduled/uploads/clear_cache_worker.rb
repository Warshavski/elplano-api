# frozen_string_literal: true

module Scheduled
  module Uploads
    # Scheduled::Uploads::ClearCacheWorker
    #
    #   Used to perform removal of the cached images
    #
    class ClearCacheWorker
      include Sidekiq::Worker

      def perform
        ::Uploads::ClearCache.call
      end
    end
  end
end
