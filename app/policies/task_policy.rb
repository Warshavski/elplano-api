# frozen_string_literal: true

# TaskPolicy
#
#   Authorization policy for task management
#
class TaskPolicy < ApplicationPolicy
  authorize :student

  # Use default rule for any controller methods
  #
  alias_rule :update?, :destroy?, to: :manage?

  def create?
    group_owner?
  end

  def manage?
    group_owner? && task_author?
  end

  private

  def task_author?
    record.author == student
  end

  def group_owner?
    student.group_owner?
  end
end
