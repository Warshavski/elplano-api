# frozen_string_literal: true

module Groups
  # Groups::LecturerPolicy
  #
  #   Authorization policy for lecturers management
  #
  class LecturerPolicy < ApplicationPolicy
    authorize :student

    # Use default rule for any controller methods
    #
    alias_rule :create?, :update?, :destroy?, to: :manage?

    def manage?
      student.group_owner?
    end
  end
end
