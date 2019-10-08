# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_admin_statistics   GET   /api/v1/admin/statistics(.:format)  api/v1/admin/statistics#show  {:format=>"json"}
#
describe Api::V1::Admin::StatisticsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/admin/statistics')).to(
      route_to('api/v1/admin/statistics#show', format: 'json')
    )
  end
end
