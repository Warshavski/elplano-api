# frozen_string_literal: true

# GroupPolicy
#
#   Authorization policy for groups management
#
class GroupPolicy < ActionPolicy::Base
  %i[update? destroy?].each do |method|
    define_method(method) { user.group_owner? }
  end

  def create?
    !user.any_group?
  end
end
