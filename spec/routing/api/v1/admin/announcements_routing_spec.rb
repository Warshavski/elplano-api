# frozen_string_literal: true

require 'rails_helper'

#
#   api_v1_admin_announcements  GET     /api/v1/admin/announcements(.:format)       api/v1/admin/announcements#index    {:format=>"json"}
#                               POST    /api/v1/admin/announcements(.:format)       api/v1/admin/announcements#create   {:format=>"json"}
#    api_v1_admin_announcement  GET     /api/v1/admin/announcements/:id(.:format)   api/v1/admin/announcements#show     {:format=>"json"}
#                               PATCH   /api/v1/admin/announcements/:id(.:format)   api/v1/admin/announcements#update   {:format=>"json"}
#                               PUT     /api/v1/admin/announcements/:id(.:format)   api/v1/admin/announcements#update   {:format=>"json"}
#                               DELETE  /api/v1/admin/announcements/:id(.:format)   api/v1/admin/announcements#destroy  {:format=>"json"}
#
describe Api::V1::Admin::AnnouncementsController, 'routing' do
  it 'routes to #index' do
    expect(get('api/v1/admin/announcements')).to(
      route_to('api/v1/admin/announcements#index', format: 'json')
    )
  end

  it 'routes to #show' do
    expect(get('api/v1/admin/announcements/1')).to(
      route_to('api/v1/admin/announcements#show', id: '1', format: 'json')
    )
  end

  it 'routes to #create' do
    expect(post('api/v1/admin/announcements')).to(
      route_to('api/v1/admin/announcements#create', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(patch('api/v1/admin/announcements/1')).to(
      route_to('api/v1/admin/announcements#update', id: '1', format: 'json')
    )
  end

  it 'routes to #update' do
    expect(put('api/v1/admin/announcements/1')).to(
      route_to('api/v1/admin/announcements#update', id: '1', format: 'json')
    )
  end

  it 'routes to #destroy' do
    expect(delete('api/v1/admin/announcements/1')).to(
      route_to('api/v1/admin/announcements#destroy', id: '1', format: 'json')
    )
  end
end
