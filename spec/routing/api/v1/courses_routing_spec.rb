require 'rails_helper'

#
# api_v1_courses  GET     /api/v1/courses(.:format)       api/v1/courses#index    {:format=>"json"}
#                 POST    /api/v1/courses(.:format)       api/v1/courses#create   {:format=>"json"}
#  api_v1_course  GET     /api/v1/courses/:id(.:format)   api/v1/courses#show     {:format=>"json"}
#                 PATCH   /api/v1/courses/:id(.:format)   api/v1/courses#update   {:format=>"json"}
#                 PUT     /api/v1/courses/:id(.:format)   api/v1/courses#update   {:format=>"json"}
#                 DELETE  /api/v1/courses/:id(.:format)   api/v1/courses#destroy  {:format=>"json"}
#
describe Api::V1::CoursesController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/courses')).to route_to('api/v1/courses#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/courses/1')).to route_to('api/v1/courses#show', id: '1', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/courses')).to route_to('api/v1/courses#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/courses/1')).to route_to('api/v1/courses#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/courses/1')).to route_to('api/v1/courses#update', id: '1', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/courses/1')).to route_to('api/v1/courses#destroy', id: '1', format: 'json')
  end
end
