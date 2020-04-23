# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_tasks_statistics   GET    /api/v1/tasks/statistics(.:format)   api/v1/tasks/statistics#show  {:format=>"json"}
#
describe Api::V1::Tasks::StatisticsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/tasks/statistics')).to(
      route_to('api/v1/tasks/statistics#show', format: 'json')
    )
  end
end
