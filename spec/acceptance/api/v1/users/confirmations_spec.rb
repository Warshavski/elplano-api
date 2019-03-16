# frozen_string_literal: true

require 'acceptance_helper'

resource 'Unlocks' do
  let_it_be(:user) { create(:user, :unconfirmed) }

  explanation <<~DESC
    User confirmation API.

    Provides the ability to confirm user.
  DESC

  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'

  get 'api/v1/users/confirmation?confirmation_token=token' do
    parameter :unlock_token, 'Unique token from email', required: true

    example 'SHOW : Confirm user' do
      explanation <<~DESC
        Confirm user
      DESC

      do_request

      expected_body = UserSerializer.new(
        user.reload,
        meta: {
          message: 'Your email address has been successfully confirmed.'
        }
      ).serialized_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end

  post 'api/v1/users/confirmation' do
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

    example 'CREATE : Send confirmation instructions' do
      explanation <<~DESC
        Create confirmation user token and send confirmation instructions to the specified email address.
      DESC

      do_request

      expected_body = {
        meta: {
          message: 'If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes.'
        }
      }.to_json.to_s

      expect(status).to eq(200)
      expect(response_body).to eq(expected_body)
    end
  end
end
