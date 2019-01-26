require 'rails_helper'

#
#   api_v1_me GET    /api/v1/me(.:format)   api/v1/users#show {:format=>"json"}
#
describe Api::V1::UsersController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/me')).to route_to('api/v1/users#show', format: 'json')
  end
end
