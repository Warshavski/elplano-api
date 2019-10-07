# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::SessionsController, type: :request do
 describe 'GET #new' do
    it 'responds with not found' do
      get('/api/v1/users/sign_in')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:user)  { create(:user) }
    let_it_be(:token) { create(:token, resource_owner_id: user.id) }

    let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }

    subject { delete '/api/v1/users/sign_out', headers: headers }

    before { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(token.reload.revoked_at).not_to be(nil) }
  end

  describe 'POST #create' do
    let_it_be(:user) { create(:user, password: '123456') }

    let(:user_params) { { login: user.email, password: '123456' } }

    subject { post '/api/v1/users/sign_in', params: { user: user_params } }

    context 'request execution' do
      before(:each) { subject }

      context 'when request params are valid' do
        include_examples 'json:api examples',
                         %w[data meta included],
                         %w[id type attributes relationships],
                         %w[email username avatar admin confirmed banned locked locale created_at updated_at],
                         %w[student recent_access_token]
      end

      context 'when request params are invalid' do
        let(:user_params) { { login: user.email, password: '654321' } }

        it { expect(response).to have_http_status(:unauthorized) }
      end

      context 'when request params are empty' do
        let(:user_params) { nil }

        it { expect(response).to have_http_status(:unauthorized) }
      end
    end

    context 'access claiming' do
      it 'claims access token' do
        expect { subject }.to change(Doorkeeper::AccessToken, :count).by(1)
      end
    end
  end
end
