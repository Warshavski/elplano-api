# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  let_it_be(:user) { create(:user, :student, password: '123456') }

  post 'api/v1/users/sign_in' do
    with_options scope: %i[user] do
      parameter :login, 'Username or email that used to identify user in application.', required: true
      parameter :password, 'Password that the user uses to log in', required: true
    end

    let(:raw_post) do
      {
        user: {
          login: user.email,
          password: '123456'
        }
      }.to_json
    end

    example 'CREATE : Authenticate user' do
      explanation <<~DESC
        Performs user authentication and returns authenticated user information.

        Users attributes :
    
          - `email` - Represents email that was used to register a user in the application(unique in application scope).
          - `username` - Represents used's user name.
          - `admin` - `false` if regular user `true`, if the user has access to application settings.
          - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
          - `banned` - `true` if the user had been locked via admin ban action otherwise `true`.
          - `locked` - `true` if the user had been locked via login failed attempt otherwise `false`.
          - `avatar_url` - Represents user's avatar.
          - `timestamps`

        Student attributes :
      
          - `full_name` - Represents concatenated student's first, last and middle names.
          - `email` - Represents email which is used to contact with the student.
          - `phone` - Represents phone which is used to contact with the student.
          - `about` - Represents some detailed information about student(BIO).
          - `social_networks` - Represents a list of social networks.
          - `president` - `true` if the user has the right to administer the group, otherwise `false`(regular group member).
          - `timestamps`

        Token attributes :

          - `access_token` - Represents access token(used to access API endpoints).
          - `refresh_token` - Represents refresh token(used to update expired access token).
          - `token_type` - Represents token type(always "Bearer").
          - `expires_in` - Represents expiration access token expiration time.
          - `created_at` - Represents access token creation date.

        Also, includes meta block and relationship to the student's group.
      DESC

      do_request

      options = {
        include: %i[recent_access_token student],
        meta: {
          message: 'Signed in successfully.'
        }
      }

      expected_body = ::Auth::UserSerializer.new(user.reload, options).serialized_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end
end
