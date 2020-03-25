# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_admin_activity_events  GET  /api/v1/admin/activity/events(.:format)  api/v1/admin/activity/events#index {:format=>"json"}
#
describe Api::V1::Admin::Activity::EventsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/activity/events')).to(
      route_to('api/v1/admin/activity/events#index', format: 'json')
    )
  end
end
