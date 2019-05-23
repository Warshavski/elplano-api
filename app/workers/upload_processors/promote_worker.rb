# frozen_string_literal: true

module UploadProcessors
  # UploadProcessors::PromoteWorker
  #
  #   [DESCRIPTION]
  #
  class PromoteWorker
    include Sidekiq::Worker

    def perform(data)
      Shrine::Attacher.promote(data)
    end
  end
end
