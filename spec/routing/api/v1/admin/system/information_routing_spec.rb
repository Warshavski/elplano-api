# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_admin_system_information GET    /api/v1/admin/system/information(.:format) api/v1/admin/system/information#show {:format=>"json"}
#
describe Api::V1::Admin::System::InformationController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/admin/system/information')).to(
      route_to('api/v1/admin/system/information#show', format: 'json')
    )
  end
end
