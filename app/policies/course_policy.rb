# frozen_string_literal: true

# CoursePolicy
#
#   Authorization policy for course management
#
# SHOULD BE :
#
#
#   authorize :student
#
#   # Use default rule for any controller methods
#   #
#   alias_rule :create?, :update?, :destroy?, to: :manage?
#
#   def manage?
#     student.group_owner?
#   end
#
class CoursePolicy < ActionPolicy::Base
  authorize :student

  %i[create? update? destroy?].each do |method|
    define_method(method) { student.group_owner? }
  end
end
