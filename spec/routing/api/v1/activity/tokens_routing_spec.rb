# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_activity_tokens  GET   /api/v1/activity/tokens(.:format)   api/v1/activity/tokens#index  {:format=>"json"}
#
describe Api::V1::Activity::TokensController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/activity/tokens')).to(
      route_to('api/v1/activity/tokens#index', format: 'json')
    )
  end
end
