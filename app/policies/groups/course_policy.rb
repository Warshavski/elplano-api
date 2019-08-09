# frozen_string_literal: true

module Groups
  # Groups::CoursePolicy
  #
  #   Authorization policy for course management
  #
  class CoursePolicy < ApplicationPolicy
    authorize :student

    # Use default rule for any controller methods
    #
    alias_rule :create?, :update?, :destroy?, to: :manage?

    def manage?
      student.group_owner?
    end
  end
end
