# frozen_string_literal: true

# LecturerPolicy
#
#   Authorization policy for lecturers management
#
class LecturerPolicy < ActionPolicy::Base
  %i[create? update? destroy?].each do |method|
    define_method(method) { user.group_owner? }
  end
end
