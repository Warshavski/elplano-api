# frozen_string_literal: true

module Events
  # Events::IndexContract
  #
  #   Used to validate filters for courses list
  #
  class IndexContract < FilterContract
    params do
      optional(:labels).filled(:str?)
      optional(:scope).filled(:str?, included_in?: Event::SCOPES)
      optional(:type).filled(:str?, included_in?: Event::TYPES)
    end
  end
end
