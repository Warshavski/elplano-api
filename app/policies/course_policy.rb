# frozen_string_literal: true

# CoursePolicy
#
#   Authorization policy for course management
#
class CoursePolicy < ActionPolicy::Base
  %i[create? update? destroy?].each do |method|
    define_method(method) { user.group_owner? }
  end
end
