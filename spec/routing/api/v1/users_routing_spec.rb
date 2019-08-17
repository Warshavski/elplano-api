# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_user   GET    /api/v1/user(.:format)   api/v1/users#show   {:format=>"json"}
#                 PATCH  /api/v1/user(.:format)   api/v1/users#update {:format=>"json"}
#                 PUT    /api/v1/user(.:format)   api/v1/users#update {:format=>"json"}
#
describe Api::V1::UsersController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/user')).to(
      route_to('api/v1/users#show', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(patch('api/v1/user')).to(
      route_to('api/v1/users#update', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/user')).to(
      route_to('api/v1/users#update', format: 'json')
    )
  end
end
