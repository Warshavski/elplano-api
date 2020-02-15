# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_group_assignments  GET     /api/v1/tasks(.:format)        api/v1/tasks#index {:format=>"json"}
#                           POST    /api/v1/tasks(.:format)        api/v1/tasks#create {:format=>"json"}
#  api_v1_group_assignment  GET     /api/v1/tasks/:id(.:format)    api/v1/tasks#show {:format=>"json"}
#                           PATCH   /api/v1/tasks/:id(.:format)    api/v1/tasks#update {:format=>"json"}
#                           PUT     /api/v1/tasks/:id(.:format)    api/v1/tasks#update {:format=>"json"}
#                           DELETE  /api/v1/tasks/:id(.:format)    api/v1/tasks#destroy {:format=>"json"}
#
describe Api::V1::TasksController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/tasks')).to route_to('api/v1/tasks#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/tasks/1')).to route_to('api/v1/tasks#show', id: '1', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/tasks')).to route_to('api/v1/tasks#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/tasks/1')).to route_to('api/v1/tasks#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/tasks/1')).to route_to('api/v1/tasks#update', id: '1', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/tasks/1')).to route_to('api/v1/tasks#destroy', id: '1', format: 'json')
  end
end
