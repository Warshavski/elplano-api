# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin emails' do
  explanation <<~DESC
    El Plano administration: Emails.

    Provides management over user mailings.

      - confirmation
      - unlock
  DESC

  let(:user)  { create(:admin) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  post 'api/v1/admin/emails' do
    with_options scope: :mailing do
      parameter :user_id, 'User identity', required: true
      parameter :type, "One of the email types #{User::MAILING_TYPES}", required: true
    end

    let(:raw_post) do
      { mailing: { user_id: user.id, type: 'confirmation' } }.to_json
    end

    example 'CREATE : Send email of the given type' do
      explanation <<~DESC
        This endpoint allows you to send confirmation or unlock instructions to a specific user.

        <b>NOTES</b> : 

          - An email will be sent only in case if a user is unconfirmed or locked(depends on the type of mailing).
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'An email was successfully sent!'
        }
      }

      expect(status).to eq(201)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
