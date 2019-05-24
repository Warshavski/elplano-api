# frozen_string_literal: true

# GroupPolicy
#
#   Authorization policy for groups management
#
# SHOULD BE :
#
#   authorize :student
#
#   # Use default rule for any controller methods
#   #
#   alias_rule :update?, :destroy?, to: :manage?
#
#   def manage?
#     student.group_owner?
#   end
#
#   def create?
#     !student.any_group?
#   end
#
class GroupPolicy < ActionPolicy::Base
  authorize :student

  %i[update? destroy?].each do |method|
    define_method(method) { student.group_owner? }
  end

  def create?
    !student.any_group?
  end
end
