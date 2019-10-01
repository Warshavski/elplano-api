# frozen_string_literal: true

module Assignments
  # Assignments::IndexContract
  #
  #   Used to validate filters for assignments list
  #
  class IndexContract < FilterContract
    params do
      optional(:course_id).filled(:int?)
      optional(:outdated).filled(:bool?)
    end
  end
end

