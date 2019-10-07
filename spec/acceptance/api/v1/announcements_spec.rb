# frozen_string_literal: true

require 'acceptance_helper'

resource 'Announcements' do
  explanation <<~DESC
    El Plano announcements API.

    Announcement attributes :

      - `message` - Represents application announcement message.
      - `background_color` - Represents the background color.
      - `foreground_color` - Represents the foreground color that can be used to write on top of a background with 'background' color.
      - `start_at` - Represents time when announcement should appear.
      - `end_at` - Represents time when announcement should disappear.
      - `timestamps`
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
      DESC

      do_request

      expected_body = AnnouncementSerializer.new([announcement]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
