# frozen_string_literal: true

# UserSerializer
#
#   Used for the user data representation
#
class UserSerializer
  include FastJsonapi::ObjectSerializer

  set_type :user

  attributes :email, :username, :admin, :created_at, :updated_at

  #
  # just stub for the first time
  #
  attribute :avatar_url do |object|
    Users::Gravatar.call(email: object.email, size: 100, username: object.username)
  end

  attribute :confirmed, &:confirmed?

  attribute :banned, &:banned?

  attribute :locked, &:access_locked?

  belongs_to :student, serializer: StudentSerializer
end
