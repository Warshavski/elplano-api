# frozen_string_literal: true

require 'sidekiq-scheduler'

module Scheduled
  module AccessTokens
    # Scheduled::AccessTokens::ClearWorker
    #
    #   Used to perform access tokens clean up in the background
    #
    class ClearWorker
      include Sidekiq::Worker

      def perform
        ::AccessTokens::Clear.call(ENV['DOORKEEPER_DAYS_TRIM_THRESHOLD'])
      end
    end
  end
end
