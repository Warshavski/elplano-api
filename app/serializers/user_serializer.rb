# frozen_string_literal: true.

# UserSerializer
#
#   Used for the user data representation
#
class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :email, :username, :created_at, :updated_at

  #
  # just stub for the first time
  #
  attribute :avatar_url do |_object|
    nil
  end
end

