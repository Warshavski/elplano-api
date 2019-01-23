# frozen_string_literal: true.

# MeSerializer
#
#   Used for the user data representation
#
class MeSerializer < UserSerializer
  attributes :admin,
             :current_sign_in_at,
             :last_sign_in_at,
             :current_sign_in_ip,
             :last_sign_in_ip,
             :confirmed_at
end

