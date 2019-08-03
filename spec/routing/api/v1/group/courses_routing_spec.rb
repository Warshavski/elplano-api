# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_group_courses  GET     /api/v1/group/courses(.:format)       api/v1/group/courses#index    {:format=>"json"}
#                       POST    /api/v1/group/courses(.:format)       api/v1/group/courses#create   {:format=>"json"}
#  api_v1_group_course  GET     /api/v1/group/courses/:id(.:format)   api/v1/group/courses#show     {:format=>"json"}
#                       PATCH   /api/v1/group/courses/:id(.:format)   api/v1/group/courses#update   {:format=>"json"}
#                       PUT     /api/v1/group/courses/:id(.:format)   api/v1/group/courses#update   {:format=>"json"}
#                       DELETE  /api/v1/group/courses/:id(.:format)   api/v1/group/courses#destroy  {:format=>"json"}
#
describe Api::V1::Group::CoursesController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/group/courses')).to route_to('api/v1/group/courses#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/group/courses/1')).to route_to('api/v1/group/courses#show', id: '1', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/group/courses')).to route_to('api/v1/group/courses#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/group/courses/1')).to route_to('api/v1/group/courses#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/group/courses/1')).to route_to('api/v1/group/courses#update', id: '1', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/group/courses/1')).to route_to('api/v1/group/courses#destroy', id: '1', format: 'json')
  end
end
