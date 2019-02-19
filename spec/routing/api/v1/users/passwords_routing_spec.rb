require 'rails_helper'

#
#  new_user_password  GET    /api/v1/users/password/new(.:format)   api/v1/users/passwords#new    {:format=>"json"}
# edit_user_password  GET    /api/v1/users/password/edit(.:format)  api/v1/users/passwords#edit   {:format=>"json"}
#      user_password  PATCH  /api/v1/users/password(.:format)       api/v1/users/passwords#update {:format=>"json"}
#                     PUT    /api/v1/users/password(.:format)       api/v1/users/passwords#update {:format=>"json"}
#                     POST   /api/v1/users/password(.:format)       api/v1/users/passwords#create {:format=>"json"}
#
describe Api::V1::Users::ConfirmationsController, 'routing' do
  it 'routes to #new' do
    expect(get('api/v1/users/password/new')).to route_to('api/v1/users/passwords#new', format: 'json')
  end

  it 'routes to #edit' do
    expect(get('api/v1/users/password/edit')).to route_to('api/v1/users/passwords#edit', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/users/password')).to route_to('api/v1/users/passwords#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/users/password')).to route_to('api/v1/users/passwords#update', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/users/password')).to route_to('api/v1/users/passwords#update', format: 'json')
  end
end
