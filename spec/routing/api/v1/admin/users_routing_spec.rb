# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_admin_users  GET     /api/v1/admin/users(.:format)       api/v1/admin/users#index    {:format=>"json"}
#    api_v1_admin_user  GET     /api/v1/admin/users/:id(.:format)   api/v1/admin/users#show     {:format=>"json"}
#                       DELETE  /api/v1/admin/users/:id(.:format)   api/v1/admin/users#destroy  {:format=>"json"}
#
describe Api::V1::Admin::UsersController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/users')).to route_to('api/v1/admin/users#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/admin/users/1')).to route_to('api/v1/admin/users#show', id: '1', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/admin/users/1')).to route_to('api/v1/admin/users#destroy', id: '1', format: 'json')
  end
end
