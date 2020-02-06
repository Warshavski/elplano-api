# frozen_string_literal: true

module Events
  # Events::IndexContract
  #
  #   Used to validate filters for courses list
  #
  class IndexContract < FilterContract
    params do
      optional(:labels).filled(:str?)
      optional(:scope).filled(:str?, included_in?: %w[authored appointed])
      optional(:type).filled(:str?, included_in?: %w[group personal])
    end
  end
end
