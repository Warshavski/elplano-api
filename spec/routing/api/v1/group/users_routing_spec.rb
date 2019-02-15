require 'rails_helper'

#
#   api_v1_group_users  GET    /api/v1/group/users(.:format)        api/v1/group/users#index  {:format=>"json"}
#   api_v1_group_user   GET    /api/v1/group/users/:id(.:format)    api/v1/group/users#show   {:format=>"json"}
#
describe Api::V1::Group::StudentsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/group/students')).to route_to('api/v1/group/students#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/group/students/1')).to route_to('api/v1/group/students#show', id: '1', format: 'json')
  end
end
