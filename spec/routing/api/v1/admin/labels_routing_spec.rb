# frozen_string_literal: true

require 'rails_helper'

#
#  api_v1_admin_labels  GET   /api/v1/admin/labels(.:format)      api/v1/admin/labels#index {:format=>"json"}
#   api_v1_admin_label  GET   /api/v1/admin/labels/:id(.:format)  api/v1/admin/labels#show  {:format=>"json"}
#
describe Api::V1::Admin::LabelsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/labels')).to(
      route_to('api/v1/admin/labels#index', format: 'json')
    )
  end

  it 'routes to #show' do
    expect(get('api/v1/admin/labels/1')).to(
      route_to('api/v1/admin/labels#show', id: '1', format: 'json')
    )
  end
end
