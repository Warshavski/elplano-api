# frozen_string_literal: true

# ActiveTokenSerializer
#
#   Used for active token data representation
#
class ActiveTokenSerializer
  include FastJsonapi::ObjectSerializer

  set_type :active_token
  set_id :token

  attributes :ip_address, :browser, :os,
             :device_name, :device_type,
             :created_at, :updated_at
end
