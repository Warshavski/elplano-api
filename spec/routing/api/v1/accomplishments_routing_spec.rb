# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_assignment_accomplishment DELETE /api/v1/assignments/:assignment_id/accomplishment(.:format) api/v1/accomplishments#destroy {:format=>"json"}
#                                  POST   /api/v1/assignments/:assignment_id/accomplishment(.:format) api/v1/accomplishments#create {:format=>"json"}
#
describe Api::V1::AccomplishmentsController, 'routing' do
  it 'routes to #create' do
    expect(post('api/v1/assignments/1/accomplishment')).to(
      route_to('api/v1/accomplishments#create', assignment_id: '1', format: 'json')
    )
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/assignments/1/accomplishment')).to(
      route_to('api/v1/accomplishments#destroy', assignment_id: '1', format: 'json')
    )
  end
end
