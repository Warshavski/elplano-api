# frozen_string_literal: true

require 'acceptance_helper'

resource 'Users' do
  let_it_be(:user) { create(:user, :unconfirmed) }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'

  get 'api/v1/users/confirmation?confirmation_token=token' do
    parameter :confirmation_token, 'Unique confirmation token from email', required: true

    example 'SHOW : Perform user confirmation' do
      explanation <<~DESC
        Provides the ability to confirm user by confirmation token from email.
      DESC

      do_request

      options = {
        meta: {
          message: 'Your email address has been successfully confirmed.'
        }
      }

      expected_body = UserSerializer.new(user.reload, options).serialized_json

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
          type: 'user',
          attributes: {
            login: user.email
          }
        }
      }.to_json
    end

    example 'CREATE : Send confirmation instructions' do
      explanation <<~DESC
        Provides the ability to request email letter with confirmation link.

        Creates confirmation user token and sends confirmation instructions to the specified email address.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
