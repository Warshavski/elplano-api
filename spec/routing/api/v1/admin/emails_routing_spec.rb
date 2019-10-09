# frozen_string_literal: true

require 'rails_helper'

#
# api_v1_admin_emails   POST   /api/v1/admin/emails(.:format)   api/v1/admin/emails#create  {:format=>"json"}
#
describe Api::V1::Admin::EmailsController, 'routing' do
  it 'routes to #show' do
    expect(post('api/v1/admin/emails')).to(
      route_to('api/v1/admin/emails#create', format: 'json')
    )
  end
end
