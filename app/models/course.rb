# frozen_string_literal: true

# Course
#
#   Used to represent courses(managed by the group owner).
#
#   NOTE : Each group has its own list of courses and they can't cross with another group.
#
class Course < ApplicationRecord
  include Deactivatable

  belongs_to :group

  has_many :lectures, dependent: :delete_all

  has_many :lecturers, through: :lectures

  has_many :events, dependent: :nullify

  validates :group, presence: true

  validates :title,
            presence: true,
            length: { maximum: 200 },
            uniqueness: { case_sensitive: false, scope: %i[group_id] }

  before_validation -> { title&.downcase! }
end
