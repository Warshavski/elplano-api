# frozen_string_literal: true

module Tasks
  # Tasks::IndexContract
  #
  #   Used to validate filters for tasks list
  #
  class IndexContract < FilterContract
    params do
      optional(:event_id).filled(:int?)
      optional(:outdated).filled(:bool?)
      optional(:accomplished).filled(:bool?)
      optional(:appointed).filled(:bool?)
    end
  end
end
