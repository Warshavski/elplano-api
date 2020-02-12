# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_invites  GET    /api/v1/invites(.:format)          api/v1/invites#index  {:format=>"json"}
#    api_v1_invite  GET    /api/v1/invites/:token(.:format)   api/v1/invites#show   {:format=>"json"}
#                   PATCH  /api/v1/invites/:token(.:format)   api/v1/invites#update {:format=>"json"}
#                   PUT    /api/v1/invites/:token(.:format)   api/v1/invites#update {:format=>"json"}
#
describe Api::V1::InvitesController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/invites')).to route_to('api/v1/invites#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/invites/token')).to route_to('api/v1/invites#show', token: 'token', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/invites/token')).to route_to('api/v1/invites#update', token: 'token', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/invites/token')).to route_to('api/v1/invites#update', token: 'token', format: 'json')
  end
end
