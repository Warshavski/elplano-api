# frozen_string_literal: true

require 'rails_helper'

#
#  api_v1_labels  GET     /api/v1/labels(.:format)      api/v1/labels#index     {:format=>"json"}
#                 POST    /api/v1/labels(.:format)      api/v1/labels#create    {:format=>"json"}
#   api_v1_label  GET     /api/v1/labels/:id(.:format)  api/v1/labels#show      {:format=>"json"}
#                 PATCH   /api/v1/labels/:id(.:format)  api/v1/labels#update    {:format=>"json"}
#                 PUT     /api/v1/labels/:id(.:format)  api/v1/labels#update    {:format=>"json"}
#                 DELETE  /api/v1/labels/:id(.:format)  api/v1/labels#destroy   {:format=>"json"}
#
describe Api::V1::LabelsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/labels')).to(
      route_to('api/v1/labels#index', format: 'json')
    )
  end

  it 'routes to #show' do
    expect(get('api/v1/labels/1')).to(
      route_to('api/v1/labels#show', id: '1', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(post('api/v1/labels')).to(
      route_to('api/v1/labels#create', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(patch('api/v1/labels/1')).to(
      route_to('api/v1/labels#update', id: '1', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/labels/1')).to(
      route_to('api/v1/labels#update', id: '1', format: 'json')
    )
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/labels/1')).to(
      route_to('api/v1/labels#destroy', id: '1', format: 'json')
    )
  end
end
