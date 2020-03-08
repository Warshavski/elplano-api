# frozen_string_literal: true

# AbuseReportSerializer
#
#   Used for abuse report data representation
#
class AbuseReportSerializer < ApplicationSerializer
  set_type :abuse_report

  attributes :message, :created_at, :updated_at

  belongs_to :reporter,
             record_type: :user,
             serializer: UserSerializer

  belongs_to :user, serializer: UserSerializer
end
