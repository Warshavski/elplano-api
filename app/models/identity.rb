# frozen_string_literal: true

# Identity
#
#   Used to log in with external provider
#
class Identity < ApplicationRecord
  belongs_to :user

  enum provider: {
    google: 10,
    facebook: 20,
    vk: 30
  }

  validates :provider, presence: true

  validates :uid,
            uniqueness: { case_sensitive: false, scope: %i[user_id] }
end
