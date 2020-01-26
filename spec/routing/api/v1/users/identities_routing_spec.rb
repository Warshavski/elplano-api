# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_users_identities   GET     /api/v1/users/identities(.:format)      api/v1/users/identities#index   {:format=>"json"}
#                           POST    /api/v1/users/identities(.:format)      api/v1/users/identities#create  {:format=>"json"}
# api_v1_users_identity     DELETE  /api/v1/users/identities/:id(.:format)  api/v1/users/identities#destroy {:format=>"json"}
#
describe Api::V1::Users::IdentitiesController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/users/identities')).to(
      route_to('api/v1/users/identities#index', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(post('api/v1/users/identities')).to(
      route_to('api/v1/users/identities#create', format: 'json')
    )
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/users/identities/1')).to(
      route_to('api/v1/users/identities#destroy', id: '1', format: 'json')
    )
  end
end
