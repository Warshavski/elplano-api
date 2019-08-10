# frozen_string_literal: true

# GroupPolicy
#
#   Authorization policy for groups management
#
class GroupPolicy < ApplicationPolicy
  authorize :student

  # Use default rule for any controller methods
  #
  alias_rule :update?, :destroy?, to: :manage?

  def manage?
    student.group_owner?
  end

  def create?
    !student.any_group?
  end
end
