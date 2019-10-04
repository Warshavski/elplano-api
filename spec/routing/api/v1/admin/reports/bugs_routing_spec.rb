# frozen_string_literal: true

require 'rails_helper'

#
#  api_v1_admin_reports_bugs  GET     /api/v1/admin/reports/bugs(.:format)       api/v1/admin/reports/bugs#index {:format=>"json"}
#   api_v1_admin_reports_bug  GET     /api/v1/admin/reports/bugs/:id(.:format)   api/v1/admin/reports/bugs#show  {:format=>"json"}
#                             DELETE  /api/v1/admin/reports/bugs/:id(.:format)   api/v1/admin/reports/bugs#destroy {:format=>"json"}
#
describe Api::V1::Admin::Reports::BugsController, 'routing' do
  it 'routes to #create' do
    expect(get('api/v1/admin/reports/bugs')).to(
      route_to('api/v1/admin/reports/bugs#index', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(get('api/v1/admin/reports/bugs/1')).to(
      route_to('api/v1/admin/reports/bugs#show', id: '1', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(delete('api/v1/admin/reports/bugs/1')).to(
      route_to('api/v1/admin/reports/bugs#destroy', id: '1', format: 'json')
    )
  end
end
