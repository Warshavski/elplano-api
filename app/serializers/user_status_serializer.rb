# frozen_string_literal: true

# UserStatusSerializer
#
#   Used for the user status data representation
#
class UserStatusSerializer < ApplicationSerializer
  set_type :user_status

  attributes :message, :emoji, :created_at, :updated_at
end
