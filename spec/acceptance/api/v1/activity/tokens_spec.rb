# frozen_string_literal: true

require 'acceptance_helper'

resource "Users's activity tokens" do
  let(:user)  { create(:user, :student, password: '123456') }
  let(:token) { create(:token, resource_owner_id: user.id).token }

  let(:authorization) { "Bearer #{token}" }

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let(:tokens_list) do
    [
      build(
        :active_token,
        browser: 'Mobile safari',
        os: 'iOS',
        device_name: 'iPhone 6',
        device_type: 'smartphone'
      )
    ]
  end

  before do
    allow(ActiveToken).to receive(:list).with(user).and_return(tokens_list)
  end

  explanation <<~DESC
    El Plano active access tokens API
    
    #{Descriptions::Model.active_token}

    <b>NOTES:</b>

      - Issued token presented by `id` property.
  DESC

  get 'api/v1/activity/tokens' do
    example "INDEX : Retrieve authenticated users's active tokens" do
      explanation <<~DESC
        Returns a list of the user's active access tokens.

        <b>NOTE:<b>

          - By default, this endpoint returns users sorted by recently created.
      DESC

      do_request

      expected_data = ActiveTokenSerializer.new(tokens_list).to_json

      expect(status).to eq(200)
      expect(response_body).to eq(expected_data)
    end
  end
end
