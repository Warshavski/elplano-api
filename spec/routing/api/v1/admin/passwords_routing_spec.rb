# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_admin_user_password  PATCH  /api/v1/admin/users/:user_id/password(.:format) api/v1/admin/passwords#update {:format=>"json"}
#                               PUT    /api/v1/admin/users/:user_id/password(.:format) api/v1/admin/passwords#update {:format=>"json"}
#
describe Api::V1::Admin::PasswordsController, 'routing' do
  it 'routes to #update' do
    expect(patch('api/v1/admin/users/1/password')).to(
      route_to('api/v1/admin/passwords#update', user_id: '1', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/admin/users/1/password')).to(
      route_to('api/v1/admin/passwords#update', user_id: '1', format: 'json')
    )
  end
end
