# frozen_string_literal: true

# InvitePolicy
#
#   Authorization policy for group invite management
#
class InvitePolicy < ActionPolicy::Base
  %i[index? show? create?].each do |method|
    define_method(method) { user.group_owner? }
  end
end
