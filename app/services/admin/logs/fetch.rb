# frozen_string_literal: true

module Admin
  module Logs
    # Admin::Logs::Fetch
    #
    #   Used to fetch latest logs
    #
    class Fetch
      LOGGERS = [Elplano::Loggers::AppLogger].freeze

      private_constant :LOGGERS

      # @see #execute
      def self.call
        new.execute
      end

      # Fetch first 2000 logs rows
      #
      def execute
        LOGGERS.map do |logger|
          { file_name: logger.file_name, logs: logger.read_latest }
        end
      end
    end
  end
end
