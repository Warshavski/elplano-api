# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_admin_reports_abuses   GET     /api/v1/admin/reports/abuses(.:format)      api/v1/admin/reports/abuses#index   {:format=>"json"}
#   api_v1_admin_reports_abus   GET     /api/v1/admin/reports/abuses/:id(.:format)  api/v1/admin/reports/abuses#show    {:format=>"json"}
#                               DELETE  /api/v1/admin/reports/abuses/:id(.:format)  api/v1/admin/reports/abuses#destroy {:format=>"json"}
#
describe Api::V1::Admin::Reports::AbusesController, 'routing' do
  it 'routes to #create' do
    expect(get('api/v1/admin/reports/abuses')).to(
      route_to('api/v1/admin/reports/abuses#index', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(get('api/v1/admin/reports/abuses/1')).to(
      route_to('api/v1/admin/reports/abuses#show', id: '1', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(delete('api/v1/admin/reports/abuses/1')).to(
      route_to('api/v1/admin/reports/abuses#destroy', id: '1', format: 'json')
    )
  end
end
