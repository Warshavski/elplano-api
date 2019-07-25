# frozen_string_literal: true

require 'acceptance_helper'

resource "User's profile" do
  let(:user)  { create(:user, :student) }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/user' do
    example "SHOW : Retrieve authenticated users's profile" do
      explanation <<~DESC
        Returns detailed information about user.

        Users attributes :
    
          - `email` - Represents email that was used to register a user in the application(unique in application scope).
          - `username` - Represents used's user name.
          - `admin` - `false` if regular user `true`, if the user has access to application settings.
          - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
          - `avatar_url` - Represents user's avatar.
          - `timestamps`

        Also, includes relationship to the student
      DESC

      do_request

      expect(status).to eq(200)
      expect(response_body).to eq(UserSerializer.new(user).serialized_json)
    end
  end
end
