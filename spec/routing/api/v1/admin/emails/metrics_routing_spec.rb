# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_admin_emails_metrics   GET   /api/v1/admin/emails/metrics(.:format)  api/v1/admin/emails/metrics#show  {:format=>"json"}
#
describe Api::V1::Admin::Emails::MetricsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/admin/emails/metrics')).to(
      route_to('api/v1/admin/emails/metrics#show', format: 'json')
    )
  end
end
