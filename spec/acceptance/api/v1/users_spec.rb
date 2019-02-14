# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  explanation "El Plano user's profile API"

  let(:user)  { create(:user, :student) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/user' do
    context 'Authorized - 200' do
      example "SHOW : Retrieve Authenticated Users's Profile" do
        explanation <<~DESC
          Users attributes :

          - `email` - represents email that was used to register a user in the application(unique in application scope)
          - `username` - used as user name
          - `admin` - `false` if regular user `true`, if the user has access to application settings
          - `confirmed` - `false` if the user did not confirm his address otherwise `true`
          - timestamps
        DESC

        do_request

        expect(status).to eq(200)
        expect(response_body).to eq(UserSerializer.new(user).serialized_json.to_s)
      end
    end

    context 'Unauthorized - 401' do
      let(:authorization) { nil }

      example 'SHOW : Returns 401 status code' do
        explanation <<~DESC
          Returns 401 status code in case of missing or invalid access token
        DESC

        do_request

        expect(status).to eq(401)
      end
    end
  end
end
