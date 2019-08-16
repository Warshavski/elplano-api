# frozen_string_literal: true

require 'rails_helper'

#
#       new_user_session  GET     /api/v1/users/sign_in(.:format)   api/v1/users/sessions#new     {:format=>"json"}
#           user_session  POST    /api/v1/users/sign_in(.:format)   api/v1/users/sessions#create  {:format=>"json"}
#   destroy_user_session  DELETE  /api/v1/users/sign_out(.:format)  api/v1/users/sessions#destroy {:format=>"json"}
#
describe Api::V1::Users::SessionsController, 'routing' do
  it 'routes to #new' do
    expect(get('api/v1/users/sign_in')).to(
      route_to('api/v1/users/sessions#new', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(post('api/v1/users/sign_in')).to(
      route_to('api/v1/users/sessions#create', format: 'json')
    )
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/users/sign_out')).to(
      route_to('api/v1/users/sessions#destroy', format: 'json')
    )
  end
end
