# frozen_string_literal: true

module Elplano
  module HealthChecks
    Result = Struct.new(:success, :message, :labels) do
      def to_h
        {
          status: success ? 'ok' : 'failed',
          message: message,
          labels: labels
        }
      end
    end
  end
end
