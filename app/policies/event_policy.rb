# frozen_string_literal: true

# EventPolicy
#
#   Authorization policy for events management
#
class EventPolicy < ApplicationPolicy
  authorize :student

  # Use default rule for any controller methods
  #
  alias_rule :create?, :update?, :destroy?, to: :manage?

  def manage?
    case record.eventable_type
    when 'Group'
      group_owner?
    when 'Student'
      self? || (student.group_owner? && classmate?)
    else
      false
    end
  end

  private

  def group_owner?
    student.supervised_group&.id == record.eventable_id
  end

  def self?
    student.id == record.eventable_id
  end

  def classmate?
    student.classmates.exists?(record.eventable_id)
  end
end
