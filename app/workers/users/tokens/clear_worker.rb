# frozen_string_literal: true

require 'sidekiq-scheduler'

module Users
  module Tokens
    # Users::Tokens::ClearWorker
    #
    #   Used to perform access tokens clean up in the background
    #
    class ClearWorker
      include Sidekiq::Worker

      def perform
        ::Users::Tokens::Clear.call(ENV['DOORKEEPER_DAYS_TRIM_THRESHOLD'])
      end
    end
  end
end
