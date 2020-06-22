# frozen_string_literal: true

module Uploads
  # Upload::DeleteWorker
  #
  #   Used to perform upload delete in background
  #
  class DeleteWorker
    include Sidekiq::Worker

    def perform(attacher_class, data)
      # TODO : consider to move logic to the service class
      attacher_class = Object.const_get(attacher_class)

      attacher_class.from_data(data).then(&:destroy)
    end
  end
end
