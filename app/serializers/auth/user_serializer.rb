# frozen_string_literal: true

module Auth
  # Auth::UserSerializer
  #
  #   Used for the user data representation
  #     (sign in info)
  #
  class UserSerializer < ::UserSerializer
    set_type :user

    belongs_to :recent_access_token,
               record_type: :access_token,
               serializer: AccessTokenSerializer
  end
end
