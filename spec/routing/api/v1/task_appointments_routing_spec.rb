# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_task_appointment   GET    /api/v1/tasks/:task_id/assignment(.:format)   api/v1/assignments#show    {:format=>"json"}
#                             PATCH  /api/v1/tasks/:task_id/assignment(.:format)   api/v1/assignments#update  {:format=>"json"}
#                             PUT    /api/v1/tasks/:task_id/assignment(.:format)   api/v1/assignments#update  {:format=>"json"}
#
describe Api::V1::AssignmentsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/tasks/1/assignment')).to(
      route_to(
        'api/v1/assignments#show', task_id: '1', format: 'json'
      )
    )
  end

  it 'routes to #update' do
    expect(patch('api/v1/tasks/1/assignment')).to(
      route_to(
        'api/v1/assignments#update', task_id: '1', format: 'json'
      )
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/tasks/1/assignment')).to(
      route_to(
        'api/v1/assignments#update', task_id: '1', format: 'json'
      )
    )
  end
end
