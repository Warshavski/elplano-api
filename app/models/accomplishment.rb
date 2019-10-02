# frozen_string_literal: true

# Accomplishment
#
#   Represents assignment accomplished by student
#
class Accomplishment < ApplicationRecord
  belongs_to :assignment
  belongs_to :student

  has_many :attachments, as: :attachable, dependent: :destroy

  validates :assignment_id, uniqueness: { scope: :student_id }
end
