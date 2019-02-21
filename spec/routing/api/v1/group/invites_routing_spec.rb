require 'rails_helper'

#
#   api_v1_group_invites  GET    /api/v1/group/invites(.:format)      api/v1/group/invites#index    {:format=>"json"}
#                         POST   /api/v1/group/invites(.:format)      api/v1/group/invites#create   {:format=>"json"}
#   api_v1_group_invite   GET    /api/v1/group/invites/:id(.:format)  api/v1/group/invites#show     {:format=>"json"}
#
describe Api::V1::Group::InvitesController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/group/invites')).to route_to('api/v1/group/invites#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/group/invites/1')).to route_to('api/v1/group/invites#show', id: '1', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/group/invites')).to route_to('api/v1/group/invites#create', format: 'json')
  end
end
