# frozen_string_literal: true

require 'acceptance_helper'

resource "User's status" do
  let(:user) { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'
  header 'Authorization', :authorization

  explanation <<~DESC
    El Plano user's status API

    #{Descriptions::Model.user_status}
  DESC

  let(:user_status) { create(:user_status, user: user) }

  get 'api/v1/status' do
    example "SHOW : Retrieve authenticated users's status" do
      explanation <<~DESC
        Returns information about user status.

        <b>MORE INFORMATION</b>

          - See attributes description in the section description.
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq(UserStatusSerializer.new(user.status).to_json)
    end
  end

  put 'api/v1/status' do
    with_options scope: :user_status do
      parameter :message, 'Represents status message'
      parameter :emoji, 'Represents status emoji name'
    end

    let(:raw_post) do
      {
        user_status: {
          message: Faker::Lorem.sentence,
          emoji: 'ribbon',
        }
      }.to_json
    end

    example "UPDATE : Create/Updates authenticated user's status" do
      explanation <<~DESC
        Creates/Updates and returns user status.

        <b>MORE INFORMATION</b>

          - See attributes description in the section description.
      DESC

      do_request

      expected_body = UserStatusSerializer.new(user.reload.status).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/status' do
    example "DELETE : Deletes user's status" do
      explanation <<~DESC
        Deletes a authenticated user's status.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
