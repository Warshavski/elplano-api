# frozen_string_literal: true

# AssignmentPolicy
#
#   Authorization policy for assignment management
#
class AssignmentPolicy < ApplicationPolicy
  authorize :student

  # Use default rule for any controller methods
  #
  alias_rule :update?, :destroy?, to: :manage?

  def create?
    group_owner?
  end

  def manage?
    group_owner? && assignment_author?
  end

  private

  def assignment_author?
    record.author == student
  end

  def group_owner?
    student.group_owner?
  end
end
