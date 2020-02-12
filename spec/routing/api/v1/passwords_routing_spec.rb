# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_password   PATCH  /api/v1/password(.:format)   api/v1/passwords#update {:format=>"json"}
#                     PUT    /api/v1/password(.:format)   api/v1/passwords#update {:format=>"json"}
#
describe Api::V1::PasswordsController, 'routing' do
  it 'routes to #update' do
    expect(patch('api/v1/password')).to route_to('api/v1/passwords#update', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/password')).to route_to('api/v1/passwords#update', format: 'json')
  end
end
