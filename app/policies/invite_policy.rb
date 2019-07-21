# frozen_string_literal: true

# InvitePolicy
#
#   Authorization policy for group invite management
#
# SHOULD BE :
#
#   authorize :student
#
#   # Use default rule for any controller methods
#   #
#   alias_rule :index?, :show?, :create?, to: :manage?
#
#   def manage?
#     student.group_owner?
#   end
#
class InvitePolicy < ActionPolicy::Base
  authorize :student

  %i[index? show? create?].each do |method|
    define_method(method) { student.group_owner? }
  end
end
