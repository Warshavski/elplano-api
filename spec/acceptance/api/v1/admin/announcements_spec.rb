# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin announcements' do
  explanation <<~DESC
    El Plano administration: Application announcements.
    
    #{Descriptions::Model.announcement}
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let_it_be(:announcement)  { create(:announcement) }
  let_it_be(:id)            { announcement.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/announcements' do
    example 'INDEX : Retrieve a list of announcements' do
      explanation <<~DESC
        Returns a list of the application announcements.

        <b>MORE INFORMATION</b>

          - See user attributes description in the section description.
  
        <b>NOTES:<b>

          - By default, this endpoint returns announcement sorted by end date(closest ones).
      DESC

      do_request

      expected_body = AnnouncementSerializer
                        .new([announcement])
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/admin/announcements/:id' do
    example 'SHOW : Retrieve information about requested announcement' do
      explanation <<~DESC
        Returns a single instance of the application announcement.

        <b>MORE INFORMATION</b>

          - See user attributes description in the section description.
      DESC

      do_request

      expected_body = AnnouncementSerializer
                        .new(announcement)
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/admin/announcements' do
    with_options scope: :announcement do
      parameter :message, 'Announcement message', required: true
      parameter :background_color, 'The background color (HEX)'
      parameter :foreground_color, "The foreground color that can be used to write on top of a background with 'background' color (HEX)"
      parameter :start_at, 'Announcement start time', required: true
      parameter :end_at, 'Announcement end time', required: true
    end

    let(:raw_post) do
      { announcement: build(:announcement_params) }.to_json
    end

    example 'CREATE : Creates new announcement' do
      explanation <<~DESC
        Creates announcement and returns created announcement.

        <b>MORE INFORMATION</b>

          - See user attributes description in the section description.
      DESC

      do_request

      expected_body = AnnouncementSerializer
                        .new(Announcement.last)
                        .to_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  patch 'api/v1/admin/announcements/:id' do
    with_options scope: :announcement do
      parameter :message, 'Announcement message', required: true
      parameter :background_color, 'The background color (HEX)'
      parameter :foreground_color, "The foreground color that can be used to write on top of a background with 'background' color (HEX)"
      parameter :start_at, 'Announcement start time', required: true
      parameter :end_at, 'Announcement end time', required: true
    end

    let(:raw_post) do
      { announcement: build(:announcement_params) }.to_json
    end

    example 'UPDATE : Updates selected announcement information' do
      explanation <<~DESC
        Updates announcement information and returns updated announcement.

        <b>MORE INFORMATION</b>

          - See user attributes description in the section description.
      DESC

      do_request

      expected_body = AnnouncementSerializer
                        .new(announcement.reload)
                        .to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/admin/announcements/:id' do
    example 'DELETE : Delete selected announcement' do
      explanation <<~DESC
        Permanently deletes announcement.
        
        <b>WARNING!</b>: This action cannot be undone.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
