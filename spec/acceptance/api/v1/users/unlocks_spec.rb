# frozen_string_literal: true

require 'acceptance_helper'

resource 'Unlocks' do
  let_it_be(:user) { create(:user, :locked) }

  explanation <<~DESC
    User unlock API.

    Provides the ability to unlock user.
  DESC

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'

  get 'api/v1/users/unlock?unlock_token=token' do
    parameter :unlock_token, 'Unique token from email', required: true

    example 'SHOW : Unlock user' do
      explanation <<~DESC
        Unlock user
      DESC

      do_request

      expected_body = {
        meta: {
          message: 'Your account has been unlocked successfully. Please sign in to continue.'
        }
      }.to_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/users/unlock' do
    with_options scope: %i[data attributes] do
      parameter :email, 'Unique email that used to identify user in application', required: true
    end

    let(:raw_post) do
      {
        data: {
          id: '',
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

      expected_body = {
        meta: {
          message: 'If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.'
        }
      }.to_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
