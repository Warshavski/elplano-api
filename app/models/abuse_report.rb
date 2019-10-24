# frozen_string_literal: true

# AbuseReport
#
#   Represents registered abuse reports
#
class AbuseReport < ApplicationRecord
  belongs_to :reporter,
             class_name: 'User',
             inverse_of: :reported_abuses

  belongs_to :user,
             inverse_of: :abuse_report

  validates :user, :reporter, :message, presence: true

  validates :user_id, uniqueness: { message: I18n.t(:'errors.messages.user.already_reported') }
end
