require 'rails_helper'

describe Api::V1::MeController do
  describe '#show' do
    context 'anonymous user' do
      before(:each) { get '/api/v1/me' }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq('') }
    end

    context 'authenticated user' do
      let(:user)  { create(:user) }
      let(:token) { create(:token, resource_owner_id: user.id) }

      before(:each) { get '/api/v1/me', headers: { 'Authorization' => "Bearer #{token.token}" } }

      it { expect(response).to have_http_status(:ok) }

      it 'responds with json-api format' do
        actual_keys = body_as_json[:data].keys

        expect(response.body).to look_like_json
        expect(actual_keys).to match_array(%w[id type attributes])
      end

      it 'returns with correct attributes' do
        actual_keys = body_as_json[:data][:attributes].keys
        expected_keys = %w[
          email
          username
          avatar_url
          created_at
          updated_at
          admin
          current_sign_in_at
          last_sign_in_at
          current_sign_in_ip
          last_sign_in_ip
          confirmed_at
        ]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'returns token owner' do
        actual_username = body_as_json[:data][:attributes][:username]

        expect(actual_username).to eq(user.username)
      end
    end
  end
end
