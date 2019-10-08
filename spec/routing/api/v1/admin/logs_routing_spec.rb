# frozen_string_literal: true

require 'rails_helper'

#
#  api_v1_admin_logs    GET    /api/v1/admin/logs(.:format)   api/v1/admin/logs#show  {:format=>"json"}
#
describe Api::V1::Admin::LogsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/admin/logs')).to(
      route_to('api/v1/admin/logs#show', format: 'json')
    )
  end
end
