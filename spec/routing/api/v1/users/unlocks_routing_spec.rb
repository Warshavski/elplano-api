# frozen_string_literal: true

require 'rails_helper'

#
#  new_user_unlock GET    /api/v1/users/unlock/new(.:format)  api/v1/users/unlocks#new    {:format=>"json"}
#      user_unlock GET    /api/v1/users/unlock(.:format)      api/v1/users/unlocks#show   {:format=>"json"}
#                  POST   /api/v1/users/unlock(.:format)      api/v1/users/unlocks#create {:format=>"json"}
#
describe Api::V1::Users::UnlocksController, 'routing' do
  it 'routes to #new' do
    expect(get('api/v1/users/unlock/new')).to route_to('api/v1/users/unlocks#new', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/users/unlock')).to route_to('api/v1/users/unlocks#show', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/users/unlock')).to route_to('api/v1/users/unlocks#create', format: 'json')
  end
end
