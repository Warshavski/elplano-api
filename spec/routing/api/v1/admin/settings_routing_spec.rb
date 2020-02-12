# frozen_string_literal: true

require 'rails_helper'

#
#  api_v1_admin_settings  PATCH  /api/v1/admin/settings(.:format)   api/v1/admin/settings#update {:format=>"json"}
#                         PUT    /api/v1/admin/settings(.:format)   api/v1/admin/settings#update {:format=>"json"}
#
describe Api::V1::Admin::SettingsController, 'routing' do
  it 'routes to #update' do
    expect(patch('api/v1/admin/settings')).to(
      route_to('api/v1/admin/settings#update', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/admin/settings')).to(
      route_to('api/v1/admin/settings#update', format: 'json')
    )
  end
end
