# frozen_string_literal: true

module Elplano
  module HealthChecks
    # Elplano::HealthChecks::DbCheck
    #
    #   Used to check DB health
    #
    class DbCheck
      extend AbstractCheck

      class << self
        private

        def metric_prefix
          'db_ping'
        end

        def successful?(result)
          result == '1'
        end

        def check
          catch_timeout(DEFAULT_TIMEOUT) do
            ActiveRecord::Base.connection.execute('SELECT 1 as ping')&.first&.[]('ping')&.to_s
          end
        end
      end
    end
  end
end
