# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  let(:user)  { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id) }

  let(:authorization) { "Bearer #{token.token}" }

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

        #{Descriptions::Model.user}

        #{Descriptions::Model.student}

        #{Descriptions::Model.access_token}

        <b>NOTES</b> :

          - Also, includes meta block and relationship to the student's group.
      DESC

      do_request

      options = {
        include: %i[recent_access_token student],
        meta: {
          message: 'Signed in successfully.'
        }
      }

      expected_body = ::Auth::UserSerializer.new(user.reload, options).to_json

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end

  delete 'api/v1/users/sign_out' do
    header 'Authorization', :authorization

    example 'DELETE : Revoke access token' do
      explanation <<~DESC
        Performs access token revoke.

        <b>NOTES</b> : 

          - Allowed only for authenticated user.
      DESC

      do_request

      expected_body = {
        meta: {
          message: 'Signed out successfully.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body.to_json)
    end
  end
end
