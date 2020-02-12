# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_group  GET    /api/v1/group(.:format)  api/v1/groups#show    {:format => "json"}
#                 PATCH  /api/v1/group(.:format)  api/v1/groups#update  {:format => "json"}
#                 PUT    /api/v1/group(.:format)  api/v1/groups#update  {:format => "json"}
#                 DELETE /api/v1/group(.:format)  api/v1/groups#destroy {:format => "json"}
#                 POST   /api/v1/group(.:format)  api/v1/groups#create  {:format => "json"}
#
describe Api::V1::GroupsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/group')).to route_to('api/v1/groups#show', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/group')).to route_to('api/v1/groups#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/group')).to route_to('api/v1/groups#update', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/group')).to route_to('api/v1/groups#update', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/group')).to route_to('api/v1/groups#destroy', format: 'json')
  end
end
