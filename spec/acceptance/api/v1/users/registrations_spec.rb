# frozen_string_literal: true

require 'acceptance_helper'

resource 'Registrations' do
  explanation <<~DESC
    User registration API.

    Users attributes :

      - `email` - Represents email that was used to register a user in the application(unique in application scope).
      - `username` - Used as user name.
      - `admin` - `false` if regular user `true`, if the user has access to application settings.
      - `confirmed` - `false` if the user did not confirm his address otherwise `true`.
      - timestamps
  DESC

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  post 'api/v1/users' do
    with_options scope: %i[data attributes] do
      parameter :username, 'Used as user name.', required: true
      parameter :email, 'Unique email that used to identify user in application', required: true
      parameter :email_confirmation, 'Email duplicate. Used to prevent typos when entering an email', required: true
      parameter :password, 'Password that the user uses to log in', required: true
      parameter :password_confirmation, 'Password duplicate. Used to prevent typos when entering a password', required: true
    end

    let(:raw_post) { { data: build(:user_params) }.to_json }

    example 'CREATE : Register new user' do
      explanation <<~DESC
        Register and return registered user.
      DESC

      do_request

      expected_body = UserSerializer.new(
        User.last,
        meta: {
          message: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
        }
      ).serialized_json.to_s

      expect(status).to eq(201)
      expect(response_body).to eq(expected_body)
    end
  end
end
