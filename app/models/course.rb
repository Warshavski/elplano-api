# frozen_string_literal: true

# Course
#
#   [DESCRIPTION]
#
class Course < ApplicationRecord
  belongs_to :group

  has_many :lectures, dependent: :delete_all

  has_many :lecturers, through: :lectures

  has_many :events, dependent: :nullify

  validates :title, :group, presence: true

  validates :title, length: { maximum: 200 }

  validates :title, uniqueness: { case_sensitive: false, scope: %i[group_id] }

  before_validation -> { title&.downcase! }
end
