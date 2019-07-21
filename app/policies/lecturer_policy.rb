# frozen_string_literal: true

# LecturerPolicy
#
#   Authorization policy for lecturers management
#
# SHOULD BE :
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
class LecturerPolicy < ActionPolicy::Base
  authorize :student

  %i[create? update? destroy?].each do |method|
    define_method(method) { student.group_owner? }
  end
end
