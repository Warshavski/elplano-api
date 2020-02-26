# frozen_string_literal: true

require 'acceptance_helper'

resource 'Announcements' do
  explanation <<~DESC
    El Plano announcements API.

    #{Descriptions::Model.announcement}
  DESC

  let(:user)  { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let_it_be(:announcement) { create(:announcement) }

  get 'api/v1/announcements' do
    example 'INDEX : Retrieve announcements list' do
      explanation <<~DESC
        Returns a list of the current application announcements.

        <b>MORE INFORMATION</b>

          - See model attributes description in the section description.
      DESC

      do_request

      expected_body = AnnouncementSerializer.new([announcement]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
