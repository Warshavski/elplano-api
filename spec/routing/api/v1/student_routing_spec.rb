require 'rails_helper'

#
#   api_v1_students   GET     /api/v1/students(.:format)   api/v1/students#show    {:format=>"json"}
#                     PATCH   /api/v1/students(.:format)   api/v1/students#update  {:format=>"json"}
#                     PUT     /api/v1/students(.:format)   api/v1/students#update  {:format=>"json"}
#
describe Api::V1::StudentsController, 'routing' do
  it 'routes to #show' do
    expect(get('api/v1/student')).to route_to('api/v1/students#show', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/student')).to route_to('api/v1/students#update', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/student')).to route_to('api/v1/students#update', format: 'json')
  end
end
