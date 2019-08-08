# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::UnlocksController do
  let_it_be(:user) { create(:user, locked_at: Time.now, unlock_token: 'wat') }

  describe 'GET #new' do
    it 'responds with not found' do
      get('/api/v1/users/unlock/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #show' do
    let(:unlock_url) { '/api/v1/users/unlock?unlock_token' }

    context 'when token is valid' do
      before { allow_any_instance_of(described_class).to receive(:unlock_access).and_return(user) }

      before(:each) { get "#{unlock_url}=#{user.unlock_token}" }

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json.keys).to match_array(['meta'])}
    end

    context 'when token is not valid' do
      before(:each) { get "#{unlock_url}=so" }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'responds with errors' do
        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe 'POST #create' do
    let(:user_params) { { email: user.email } }

    context 'when request params is valid' do
      before(:each) { post '/api/v1/users/unlock', params: { user: user_params } }

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json.keys).to match_array(['meta'])}
    end

    context 'when request params are not valid' do
      before { allow_any_instance_of(described_class).to receive(:successfully_sent?).and_return(false) }

      context 'when request params are not provided' do
        before(:each) { post '/api/v1/users/unlock' }

        it { expect(response).to have_http_status(:bad_request) }

        it 'responds with errors' do
          actual_keys = body_as_json[:errors].first.keys
          expected_keys = %w[status source detail]

          expect(actual_keys).to match_array(expected_keys)
        end
      end

      context 'when not valid params are provided' do
        before(:each) { post '/api/v1/users/unlock', params: { user: user_params } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
