# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  post 'api/v1/users' do
    with_options scope: %i[user] do
      parameter :username, 'Used as user name.', required: true
      parameter :email, 'Unique email that used to identify user in application', required: true
      parameter :password, 'Password that the user uses to log in', required: true
      parameter :password_confirmation, 'Password duplicate. Used to prevent typos when entering a password', required: true
    end

    let(:raw_post) { { user: build(:user_params) }.to_json }

    example 'CREATE : Register new user' do
      explanation <<~DESC
        Performs user registration and returns registered user.

        Also, it sends an email with instructions for confirming the user.

        #{Descriptions::Model.user}

        <b>NOTES</b> :

          - Also, includes relationship to the student.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
        }
      }

      expect(status).to eq(201)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
