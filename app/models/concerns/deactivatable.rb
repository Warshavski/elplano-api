# frozen_string_literal: true

# Deactivatable
#
#   Provides additions to activate/deactivate model entity
#
module Deactivatable
  extend ActiveSupport::Concern

  included do
    scope :active,      -> { where(active: true) }
    scope :deactivated, -> { where(active: false) }

    def activate!
      update!(active: true)
    end

    def deactivate!
      update!(active: false)
    end
  end
end
