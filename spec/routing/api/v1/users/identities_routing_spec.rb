require 'rails_helper'

#
#  api_v1_users_identities POST   /api/v1/users/identities(.:format)  api/v1/users/identities#create {:format=>"json"}
#
describe Api::V1::Users::IdentitiesController, 'routing' do
  it 'routes to #create' do
    expect(post('api/v1/users/identities')).to route_to('api/v1/users/identities#create', format: 'json')
  end
end
