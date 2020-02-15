# frozen_string_literal: true

# Assignment
#
#   Represents link between task and student who should complete this task
#
class Assignment < ApplicationRecord
  belongs_to :task
  belongs_to :student

  has_many :attachments, as: :attachable, dependent: :destroy

  scope :accomplished, -> { where(accomplished: true) }
  scope :unfulfilled, -> { where(accomplished: false) }

  validates :task_id, uniqueness: { scope: :student_id }
end
