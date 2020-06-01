# frozen_string_literal: true

module Courses
  # Courses::IndexContract
  #
  #   Used to validate filters for courses list
  #
  class IndexContract < FilterContract
    params do
      optional(:active).type(:bool).filled(:bool?)
    end
  end
end
