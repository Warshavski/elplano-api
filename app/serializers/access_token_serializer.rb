# frozen_string_literal: true

# AccessTokenSerializer
#
#   Used for the access token data representation
#
class AccessTokenSerializer
  include FastJsonapi::ObjectSerializer

  set_type :access_token

  attributes :access_token, :refresh_token,
             :token_type, :expires_in, :created_at

  attribute :access_token, &:token

  attribute :created_at do |object|
    object.created_at.to_i
  end
end
