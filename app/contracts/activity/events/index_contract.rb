# frozen_string_literal: true

module Activity
  module Events
    # Activity::Events::IndexContract
    #
    #   Used to validate filters for activity events list
    #
    class IndexContract < FilterContract
      params do
        optional(:action).filled(:str?, included_in?: ActivityEvent.actions.keys)
      end
    end
  end
end
