# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_admin_groups   GET    /api/v1/admin/groups(.:format)       api/v1/admin/groups#index {:format=>"json"}
#  api_v1_admin_group   GET    /api/v1/admin/groups/:id(.:format)   api/v1/admin/groups#show {:format=>"json"}
#
describe Api::V1::Admin::GroupsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/groups')).to(
      route_to('api/v1/admin/groups#index', format: 'json')
    )
  end

  it 'routes to #show' do
    expect(get('api/v1/admin/groups/1')).to(
      route_to('api/v1/admin/groups#show', id: '1', format: 'json')
    )
  end
end
