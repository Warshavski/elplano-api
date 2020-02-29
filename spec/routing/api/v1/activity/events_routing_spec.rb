# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_activity_events  GET   /api/v1/activity/events(.:format)  api/v1/activity/events#index {:format=>"json"}
#
describe Api::V1::Activity::EventsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/activity/events')).to(
      route_to('api/v1/activity/events#index', format: 'json')
    )
  end
end
