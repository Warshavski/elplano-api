# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_reports_bugs   POST   /api/v1/reports/bugs(.:format)   api/v1/reports/bugs#create {:format=>"json"}
#
describe Api::V1::Reports::BugsController, 'routing' do
  it 'routes to #create' do
    expect(post('api/v1/reports/bugs')).to(
      route_to('api/v1/reports/bugs#create', format: 'json')
    )
  end
end
