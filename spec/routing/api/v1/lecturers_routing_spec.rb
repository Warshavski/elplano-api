require 'rails_helper'

#
# api_v1_lecturers  GET     /api/v1/lecturers(.:format)       api/v1/lecturers#index    {:format=>"json"}
#                   POST    /api/v1/lecturers(.:format)       api/v1/lecturers#create   {:format=>"json"}
#  api_v1_lecturer  GET     /api/v1/lecturers/:id(.:format)   api/v1/lecturers#show     {:format=>"json"}
#                   PATCH   /api/v1/lecturers/:id(.:format)   api/v1/lecturers#update   {:format=>"json"}
#                   PUT     /api/v1/lecturers/:id(.:format)   api/v1/lecturers#update   {:format=>"json"}
#                   DELETE  /api/v1/lecturers/:id(.:format)   api/v1/lecturers#destroy  {:format=>"json"}
#
describe Api::V1::LecturersController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/lecturers')).to route_to('api/v1/lecturers#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/lecturers/1')).to route_to('api/v1/lecturers#show', id: '1', format: 'json')
  end

  it 'routes to #create' do
    expect(post('api/v1/lecturers')).to route_to('api/v1/lecturers#create', format: 'json')
  end

  it 'routes to #update' do
    expect(patch('api/v1/lecturers/1')).to route_to('api/v1/lecturers#update', id: '1', format: 'json')
  end

  it 'routes to #update' do
    expect(put('api/v1/lecturers/1')).to route_to('api/v1/lecturers#update', id: '1', format: 'json')
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/lecturers/1')).to route_to('api/v1/lecturers#destroy', id: '1', format: 'json')
  end
end
