# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_reports_abuses   POST   /api/v1/reports/abuses(.:format)   api/v1/reports/abuses#create  {:format=>"json"}
#
describe Api::V1::Reports::AbusesController, 'routing' do
  it 'routes to #create' do
    expect(post('api/v1/reports/abuses')).to(
      route_to('api/v1/reports/abuses#create', format: 'json')
    )
  end
end
