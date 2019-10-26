# frozen_string_literal: true

require 'acceptance_helper'

resource "Users's reports abuses" do
  explanation <<~DESC
    El Plano abuses reports API.
    
    Abuse report attributes :

     - `message` - Represents abuse report message.
     - `user_id` - Represents reported users identity
     - `timestamps`
  DESC

  let(:user)  { create(:user) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  post 'api/v1/reports/abuses' do
    with_options scope: :report do
      parameter :message, 'Abuse report message(abuse description)', required: true
      parameter :user_id, 'Reported user identity', required: true
    end

    let_it_be(:reported_user) { create(:user) }

    let(:raw_post) do
      {
        report: {
          message: 'Bang! You have been reported!',
          user_id: reported_user.id
        }
      }.to_json
    end

    example 'CREATE : Creates abuse report' do
      explanation <<~DESC
        Report abuse(create a new abuse report)

        See model attributes description in the section description.
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'Thank you, your report has been registered.'
        }
      }

      expect(status).to eq(201)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end