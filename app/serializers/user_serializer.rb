# frozen_string_literal: true.

# UserSerializer
#
#   Used for the user data representation
#
class UserSerializer
  include FastJsonapi::ObjectSerializer

  attributes :email, :username, :admin, :created_at, :updated_at

  #
  # just stub for the first time
  #
  attribute :avatar_url do |object|
    Users::Gravatar.new.generate(object.email, 100, 2, username: object.username)
  end

  attribute :confirmed do |object|
    object.confirmation_token && object.confirmed_at.nil? ? false : true
  end

  belongs_to :student, serializer: StudentSerializer
end

