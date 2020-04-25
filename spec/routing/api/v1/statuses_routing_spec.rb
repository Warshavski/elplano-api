# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_status   GET     /api/v1/status(.:format)    api/v1/statuses#show    {:format=>"json"}
#                 PATCH   /api/v1/status(.:format)    api/v1/statuses#update  {:format=>"json"}
#                 PUT     /api/v1/status(.:format)    api/v1/statuses#update  {:format=>"json"}
#                 DELETE  /api/v1/status(.:format)    api/v1/statuses#destroy {:format=>"json"}
#
describe Api::V1::StatusesController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/status')).to(
      route_to('api/v1/statuses#show', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/status')).to(
      route_to('api/v1/statuses#update', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(patch('api/v1/status')).to(
      route_to('api/v1/statuses#update', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(delete('api/v1/status')).to(
      route_to('api/v1/statuses#destroy', format: 'json')
    )
  end
end
