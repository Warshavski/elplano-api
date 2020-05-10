# frozen_string_literal: true
module Events
  # Events::Base
  #
  #   Contains common logic across all events related services
  #
  class Base
    include Loggable

    private

    def save_with_logging!(event, action, details: nil)
      ApplicationRecord.transaction do
        event.save!

        event.tap do |e|
          log_activity!(action, e.creator.user, e, details: details)
        end
      end
    end
  end
end
