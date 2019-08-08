# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::ConfirmationsController do
  let_it_be(:user) { create(:user, confirmation_token: 'wat', confirmed_at: nil) }

  describe 'GET #new' do
    it 'responds with not found' do
      get('/api/v1/users/confirmation/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #show' do
    let(:confirmation_url) { '/api/v1/users/confirmation?confirmation_token' }

    context 'when token is valid' do
      before(:each) { get "#{confirmation_url}=#{user.confirmation_token}" }

      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data meta],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]

      it 'confirms user registration' do
        expect(user.reload.confirmed_at).to_not be_nil
      end
    end

    context 'when token is not valid' do
      before(:each) { get "#{confirmation_url}=so" }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'responds with errors' do
        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe 'POST #create' do
    let(:user_params) do
      { login: user.email }
    end

    context 'when request params are valid' do
      before(:each) { post '/api/v1/users/confirmation', params: { user: user_params } }

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json.keys).to match_array(['meta'])}
    end

    context 'when request params are not valid' do
      before { allow_any_instance_of(described_class).to receive(:successfully_sent?).and_return(false) }

      context 'when no params are not provided' do
        before(:each) { post '/api/v1/users/confirmation' }

        it { expect(response).to have_http_status(:bad_request) }

        it 'responds with errors' do
          actual_keys = body_as_json[:errors].first.keys
          expected_keys = %w[status source detail]

          expect(actual_keys).to match_array(expected_keys)
        end
      end

      context 'when invalid params are provided' do
        before(:each) { post '/api/v1/users/confirmation', params: { user: user_params } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
