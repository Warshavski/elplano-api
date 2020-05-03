# frozen_string_literal: true

require 'acceptance_helper'

resource 'Admin users password' do
  explanation <<~DESC
    El Plano administration: users password API.

    Manual password reset.
  DESC

  let_it_be(:user)  { create(:user, :admin, password: '123456') }
  let_it_be(:token) { create(:token, resource_owner_id: user.id) }

  let_it_be(:random_user) { create(:user) }

  let_it_be(:user_id) { random_user.id }

  let(:password_params) do
    {
      password: '654321',
      password_confirmation: '654321'
    }
  end

  header 'Accept',        'application/vnd.api+json'
  header 'Content-Type',  'application/vnd.api+json'
  header 'Authorization', :authorization

  let(:authorization) { "Bearer #{token.token}" }

  put 'api/v1/admin/users/:user_id/password' do
    with_options scope: %i[user] do
      parameter :password, 'New password', required: true
      parameter :password_confirmation, 'New password confirmation', required: true
    end

    let(:raw_post) do
      { user: password_params }.to_json
    end

    example "UPDATE : Updates user's password" do
      explanation <<~DESC
        Perform user's password reset(change to the new one).
      DESC

      do_request

      expected_meta = {
        meta: {
          message: 'Your password has been changed successfully.'
        }
      }

      expect(status).to eq(200)
      expect(response_body).to eq(expected_meta.to_json)
    end
  end
end
