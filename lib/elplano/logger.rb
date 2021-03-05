# frozen_string_literal: true

module Elplano
  # Elplano::Logger
  #
  #   Basic logger
  #
  class Logger < ::Logger
    FILE_EXTENSION = 'log'
    LATEST_COUNT = 2000

    class << self
      delegate :debug, :error, :warn, :info, to: :build

      def file_name
        "#{file_name_noext}.#{FILE_EXTENSION}"
      end

      def read_latest
        path = full_log_path

        return [] unless File.readable?(path)

        tail, = Elplano::Popen.popen(%W[tail -n #{LATEST_COUNT} #{path}])
        tail.split("\n")
      end

      private

      def build
        Elplano::RequestStore::SafeStore[cache_key] ||= new(full_log_path)
      end

      def full_log_path
        Rails.root.join(FILE_EXTENSION, file_name)
      end

      def cache_key
        "logger:#{full_log_path}"
      end
    end
  end
end
