# frozen_string_literal: true

# AccessToken
#
#   Represents access token
#
class AccessToken < Doorkeeper::AccessToken
  belongs_to :owner,
             foreign_key: :resource_owner_id,
             class_name: 'User'
end
