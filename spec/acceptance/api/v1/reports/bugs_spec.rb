# frozen_string_literal: true

require 'acceptance_helper'

resource "Users's reports bugs" do
  explanation <<~DESC
    El Plano bugs reports API.
    
    Bug report attributes :

     - `message` - Represents bug report message.
     - `timestamps`
  DESC

  let(:user)  { create(:user) }
  let(:token) { create(:token, resource_owner_id: user.id).token }
  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  post 'api/v1/reports/bugs' do
    with_options scope: :report do
      parameter :message, 'Bug report message(bug description)', required: true
    end

    let(:raw_post) do
      { report: { message: 'Oh snap! Something bad happened! (ノಠ益ಠ)ノ彡┻━┻' } }.to_json
    end

    example 'CREATE : Creates bug report' do
      explanation <<~DESC
        Report bug(create a new bug report)

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
