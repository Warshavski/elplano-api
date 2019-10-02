# frozen_string_literal: true

require 'rails_helper'

#
#  api_v1_classmates  GET   /api/v1/classmates(.:format)      api/v1/classmates#index {:format=>"json"}
#   api_v1_classmate  GET   /api/v1/classmates/:id(.:format)  api/v1/classmates#show  {:format=>"json"}
#
describe Api::V1::ClassmatesController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/classmates')).to route_to('api/v1/classmates#index', format: 'json')
  end

  it 'routes to #show' do
    expect(get('api/v1/classmates/1')).to route_to('api/v1/classmates#show', id: '1', format: 'json')
  end
end
