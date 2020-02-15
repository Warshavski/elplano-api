# frozen_string_literal: true

# Finder
#
#   User as base class for all finders and contains common logic
#
class Finder
  include Paginatable

  def self.call(*args)
    new(*args).execute
  end

  def execute
    raise NotImplementedError
  end
end
