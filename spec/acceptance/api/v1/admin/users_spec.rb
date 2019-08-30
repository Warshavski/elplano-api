# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin users' do
  explanation <<~DESC
    El Plano administration: Users.
    
    Users attributes :

      - `email` - Represents email that was used to register a user in the application(unique in application scope).
      - `username` - Represents used's user name.
      - `admin` - `false` if regular user `true`, if the user has access to application settings.
      - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
      - `banned` - `true` if the user had been locked via admin ban action otherwise `true`.
      - `locked` - `true` if the user had been locked via login failed attempt otherwise `false`.
      - `avatar_url` - Represents user's avatar.
      - `timestamps`

      Also, include reference to student profile(additional user info)
  DESC

  let(:user)  { create(:admin, :student) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  let(:random_user) { create(:user, :student) }
  let(:id)          { random_user.id }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  get 'api/v1/admin/users' do
    example 'INDEX : Retrieve a list of users' do
      explanation <<~DESC
        Returns a list of the application users.

        <b>Optional filter params</b> :

        - `"status": "confirmed"` - Returns users filtered by one of the status(`active`, `confirmed`, `banned`).
        - `"search": "part_of_the_username_or_email"` - Returns users founded by provided search term(email, username).

        Example: 

        <pre>
        {
          "filters": {
            "status": "active",
            "search": "wat@email_or_username"
          }
        }
        </pre>

        For more details see "Filters" and "Pagination" sections in the README section. 

        <b>NOTE:<b>

          - By default, this endpoint returns users sorted by recently created.
          - By default, this endpoint returns users without status assumptions.
          - By default, this endpoint returns users limited by 15

        See user attributes description in the section description.
      DESC

      do_request

      expected_body = UserSerializer.new([user]).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  get 'api/v1/admin/users/:id' do
    example 'SHOW : Retrieve information about requested user' do
      explanation <<~DESC
        Returns a single instance of the user.

        See user attributes description in the section description.
      DESC

      do_request

      expected_body = UserSerializer.new(random_user).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  patch 'api/v1/admin/users/:id' do
    parameter :action_type, 'One of the action types(`ban`, `unban`, `unlock`, `confirm`)', required: true

    let(:raw_post) do
      { action_type: 'ban' }.to_json
    end

    example 'UPDATE : Updates selected user state' do
      explanation <<~DESC
        Updates user state and returns updated user.

        Available actions list:

          - `ban` - Block access to the application.
          - `unban` - Remove application access block.
          - `unlock` - Remove lock caused by wrong password input.
          - `confirm` - Confirm user account.

        See user attributes description in the section description.
      DESC

      do_request

      expected_body = UserSerializer.new(random_user.reload).serialized_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/admin/users/:id' do
    example 'DELETE : Delete selected user' do
      explanation <<~DESC
        Permanently deletes user and all related to that user data.
        
        <b>WARNING!</b>: This action cannot be undone.
      DESC

      do_request

      expect(status).to eq(204)
    end
  end
end
