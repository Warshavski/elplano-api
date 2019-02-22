# frozen_string_literal: true

module UploadProcessors
  # UploadProcessors::DeleteWorker
  #
  #   [DESCRIPTION]
  #
  class DeleteWorker
    include Sidekiq::Worker

    def perform(data)
      Shrine::Attacher.delete(data)
    end
  end
end
