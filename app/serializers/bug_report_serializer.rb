# frozen_string_literal: true

# BugReportSerializer
#
#   Used for bug report data representation
#
class BugReportSerializer < ApplicationSerializer
  set_type :bug_report

  attributes :message, :created_at, :updated_at
end
