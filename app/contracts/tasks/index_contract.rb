# frozen_string_literal: true

module Tasks
  # Tasks::IndexContract
  #
  #   Used to validate filters for tasks list
  #
  class IndexContract < FilterContract
    params do
      optional(:event_id)
        .type(:integer)
        .filled(:int?)

      optional(:expiration)
        .filled(:str?, included_in?: Task::EXPIRATION_SCOPES)

      optional(:accomplished)
        .type(:bool)
        .filled(:bool?)

      optional(:appointed)
        .type(:bool)
        .filled(:bool?)
    end
  end
end
