# frozen_string_literal: true

module Elplano
  module Loggers
    # Elplano::Loggers::AppLogger
    #
    #   Logger for the application events
    #
    class AppLogger < Elplano::Logger
      def self.file_name_noext
        'application'
      end

      def format_message(severity, timestamp, progname, msg)
        "#{severity} -- [#{timestamp.to_s(:long)}] : #{msg}\n"
      end
    end
  end
end
