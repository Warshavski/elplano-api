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

  attribute :extra_links, ExtraLink.to_array_type

  validates :extra_links, store_model: { merge_errors: true }, allow_nil: true

  validates :task_id, uniqueness: { scope: :student_id }
end
