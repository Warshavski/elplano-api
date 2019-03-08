# frozen_string_literal: true

require 'sidekiq-scheduler'

# ClearTokensWorker
#
#   Used to clear revoked and expired access and access grants tokens
#
class ClearTokensWorker
  include Sidekiq::Worker

  def perform(days = ENV['DOORKEEPER_DAYS_TRIM_THRESHOLD'])
    delete_before = (days || 30).to_i.days.ago

    expire_query = <<~SQL.squish
      (revoked_at IS NOT NULL AND revoked_at < :delete_before) OR 
      (expires_in IS NOT NULL AND (created_at + expires_in * INTERVAL '1 second') < :delete_before)
    SQL

    expire_params = [
      expire_query,
      { delete_before: delete_before }
    ]

    Doorkeeper::AccessGrant.where(expire_params).delete_all
    Doorkeeper::AccessToken.where(expire_params).delete_all
  end
end
