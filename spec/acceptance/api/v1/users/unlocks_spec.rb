# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  let_it_be(:user) { create(:user, :locked) }

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'

  get 'api/v1/users/unlock?unlock_token=token' do
    parameter :unlock_token, 'Unique token from email', required: true

    example 'SHOW : Perform user unlock' do
      explanation <<~DESC
        Provides the ability to unlock locked user.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'Your account has been unlocked successfully. Please sign in to continue.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end

  post 'api/v1/users/unlock' do
    with_options scope: %i[data attributes] do
      parameter :email, 'Unique email that used to identify user in application', required: true
    end

    let(:raw_post) do
      {
        data: {
          type: 'user',
          attributes: {
            login: user.email
          }
        }
      }.to_json
    end

    example 'CREATE : Send unlock instructions' do
      explanation <<~DESC
        Create unlock user token and send unlock instructions to the specified email address.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
