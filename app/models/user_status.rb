# frozen_string_literal: true

# UserStatus
#
#   Represents a registered user status
#
class UserStatus < ApplicationRecord
  belongs_to :user

  validates :user, presence: true

  validates :message, length: { maximum: 100 }, allow_blank: true

  validate do |status|
    errors.add(:emoji, :invalid) unless Emoji.find_by_alias(status.emoji)
  end
end
