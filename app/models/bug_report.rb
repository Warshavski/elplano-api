# frozen_string_literal: true

# BugReport
#
#   Represents application bugs reported by users
#
class BugReport < ApplicationRecord
  belongs_to :reporter,
             class_name: 'User',
             inverse_of: :reported_bugs

  validates :reporter, :message, presence: true
end
