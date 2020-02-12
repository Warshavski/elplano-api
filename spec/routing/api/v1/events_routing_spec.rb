# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_events   GET     /api/v1/events(.:format)        api/v1/events#index   {:format=>"json"}
#                   POST    /api/v1/events(.:format)        api/v1/events#create  {:format=>"json"}
#   api_v1_event    GET     /api/v1/events/:id(.:format)    api/v1/events#show    {:format=>"json"}
#                   PATCH   /api/v1/events/:id(.:format)    api/v1/events#update  {:format=>"json"}
#                   PUT     /api/v1/events/:id(.:format)    api/v1/events#update  {:format=>"json"}
#                   DELETE  /api/v1/events/:id(.:format)    api/v1/events#destroy {:format=>"json"}
#
describe Api::V1::EventsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/events')).to route_to('api/v1/events#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/events/1')).to route_to('api/v1/events#show', id: '1', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/events')).to route_to('api/v1/events#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/events/1')).to route_to('api/v1/events#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/events/1')).to route_to('api/v1/events#update', id: '1', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/events/1')).to route_to('api/v1/events#destroy', id: '1', format: 'json')
  end
end
