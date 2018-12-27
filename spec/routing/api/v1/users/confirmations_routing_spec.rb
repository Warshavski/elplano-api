require 'rails_helper'

#
#  new_user_confirmation GET    /api/v1/users/confirmation/new(.:format)  api/v1/users/confirmations#new    {:format=>"json"}
#      user_confirmation GET    /api/v1/users/confirmation(.:format)      api/v1/users/confirmations#show   {:format=>"json"}
#                        POST   /api/v1/users/confirmation(.:format)      api/v1/users/confirmations#create {:format=>"json"}
#
describe Api::V1::Users::ConfirmationsController, 'routing' do
  it 'routes to #new' do
    expect(get('api/v1/users/confirmation/new')).to route_to('api/v1/users/confirmations#new', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/users/confirmation')).to route_to('api/v1/users/confirmations#show', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/users/confirmation')).to route_to('api/v1/users/confirmations#create', format: 'json')
  end
end
