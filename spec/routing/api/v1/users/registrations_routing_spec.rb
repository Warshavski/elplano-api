# frozen_string_literal: true

require 'rails_helper'

#
# cancel_user_registration GET    /api/v1/users/cancel(.:format)    api/v1/users/registrations#cancel   {:format=>"json"}
#    new_user_registration GET    /api/v1/users/sign_up(.:format)   api/v1/users/registrations#new      {:format=>"json"}
#   edit_user_registration GET    /api/v1/users/edit(.:format)      api/v1/users/registrations#edit     {:format=>"json"}
#        user_registration PATCH  /api/v1/users(.:format)           api/v1/users/registrations#update   {:format=>"json"}
#                          PUT    /api/v1/users(.:format)           api/v1/users/registrations#update   {:format=>"json"}
#                          DELETE /api/v1/users(.:format)           api/v1/users/registrations#destroy  {:format=>"json"}
#                          POST   /api/v1/users(.:format)           api/v1/users/registrations#create   {:format=>"json"}
#
describe Api::V1::Users::RegistrationsController, 'routing' do
  it 'routes to #cancel' do
    expect(get('api/v1/users/cancel')).to route_to('api/v1/users/registrations#cancel', format: 'json')
  end

  it 'routes to #new' do
    expect(get('api/v1/users/sign_up')).to route_to('api/v1/users/registrations#new', format: 'json')
  end

  it 'routes to #edit' do
    expect(get('api/v1/users/edit')).to route_to('api/v1/users/registrations#edit', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/users')).to route_to('api/v1/users/registrations#update', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/users')).to route_to('api/v1/users/registrations#update', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/users')).to route_to('api/v1/users/registrations#destroy', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/users')).to route_to('api/v1/users/registrations#create', format: 'json')
  end
end
