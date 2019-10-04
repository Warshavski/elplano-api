# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_announcements  GET   /api/v1/announcements(.:format)   api/v1/announcements#index  {:format=>"json"}
#
describe Api::V1::AnnouncementsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/announcements')).to(
      route_to('api/v1/announcements#index', format: 'json')
    )
  end
end
