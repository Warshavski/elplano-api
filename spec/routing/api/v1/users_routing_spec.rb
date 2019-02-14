require 'rails_helper'

#
#   api_v1_user GET    /api/v1/user(.:format)   api/v1/users#show {:format=>"json"}
#
describe Api::V1::UsersController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/user')).to route_to('api/v1/users#show', format: 'json')
  end
end
