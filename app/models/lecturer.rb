# frozen_string_literal: true

# Lecturer
#
#   Used to represents lecturer(teacher).
#
#   NOTE : For now, all lecturers presented not as users, they must be managed by group owner.
#          Each group has its own list of lecturers and they can't cross with another group.
#
class Lecturer < ApplicationRecord
  include AvatarUploader[:avatar]

  include Deactivatable

  belongs_to :group

  has_many :lectures, dependent: :delete_all

  has_many :courses, through: :lectures

  validates :first_name, :last_name, :patronymic, presence: true, length: { maximum: 40 }

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true

  validates :group, presence: true

  validates :group_id,
            uniqueness: {
              case_sensitive: false,
              scope: %i[first_name last_name patronymic]
            }

  before_validation :downcase_attributes!

  def downcase_attributes!
    %i[first_name last_name patronymic email].each do |accessor|
      public_send(accessor)&.downcase!
    end
  end
end
