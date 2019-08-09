# frozen_string_literal: true

module Groups
  # Groups::InvitePolicy
  #
  #   Authorization policy for group invite management
  #
  class InvitePolicy < ApplicationPolicy
    authorize :student

    # Use default rule for any controller methods
    #
    alias_rule :index?, :show?, :create?, to: :manage?

    def manage?
      student.group_owner?
    end
  end
end
