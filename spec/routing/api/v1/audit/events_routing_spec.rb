# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_audit_events   GET    /api/v1/audit/events(.:format)   api/v1/audit/events#index {:format=>"json"}
#
describe Api::V1::Audit::EventsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/audit/events')).to(
      route_to('api/v1/audit/events#index', format: 'json')
    )
  end
end
