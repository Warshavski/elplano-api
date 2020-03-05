# frozen_string_literal: true

require 'puma'
require 'puma/cli'

module Elplano
  # Elplano::Runtime
  #
  #   [DESCRIPTION]
  #
  module Runtime
    class << self
      def multi_threaded?
        sidekiq?
      end

      def sidekiq?
        defined?(::Sidekiq) && Sidekiq.server?
      end

      def max_threads
        main_thread = 1

        if sidekiq?
          sidekiq_threads(main_thread)
        else
          main_thread
        end
      end

      private

      def sidekiq_threads(main_thread)
        ::Sidekiq.options[:concurrency] + main_thread
      end
    end
  end
end
