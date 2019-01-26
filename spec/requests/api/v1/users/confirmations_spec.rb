require 'rails_helper'

describe Api::V1::Users::ConfirmationsController do
  let(:user) { create(:user, confirmation_token: 'wat', confirmed_at: nil) }

  describe '#new' do
    it 'responds with not found' do
      get('/api/v1/users/confirmation/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#show' do
    let(:confirmation_url) { '/api/v1/users/confirmation?confirmation_token' }

    context 'valid token' do
      before(:each) { get "#{confirmation_url}=#{user.confirmation_token}" }

      it { expect(response).to have_http_status(:ok) }

      it 'responds with json-api format' do
        actual_keys = body_as_json[:data].keys

        expect(response.body).to look_like_json
        expect(actual_keys).to match_array(%w[id type attributes relationships])
      end

      it { expect(body_as_json).to include(:meta) }

      it 'returns with correct attributes' do
        actual_keys = body_as_json[:data][:attributes].keys
        expected_keys = %w[email username avatar_url admin confirmed created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'confirms user registration' do
        expect(user.reload.confirmed_at).to_not be_nil
      end
    end

    context 'invalid token' do
      before(:each) { get "#{confirmation_url}=so" }

      it { expect(response).to have_http_status(:unprocessable_entity) }

      it 'responds with errors' do
        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe '#create' do
    let(:user_params) do
      {
        type: 'User',
        attributes: {
          email: user.email
        }
      }
    end

    context 'valid params' do
      before(:each) { post '/api/v1/users/confirmation', params: { data: user_params } }

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json).to include(:meta) }

      it 'responds with json-api format' do
        actual_keys = body_as_json[:data].keys

        expect(response.body).to look_like_json
        expect(actual_keys).to match_array(%w[id type attributes relationships])
      end

      it 'returns with correct attributes' do
        actual_keys = body_as_json[:data][:attributes].keys
        expected_keys = %w[email username avatar_url admin confirmed created_at updated_at]

        expect(actual_keys).to match_array(expected_keys)
      end
    end

    context 'invalid params' do
      before { allow_any_instance_of(described_class).to receive(:successfully_sent?).and_return(false) }

      context 'bad request' do
        before(:each) { post '/api/v1/users/confirmation' }

        it { expect(response).to have_http_status(:bad_request) }

        it 'responds with errors' do
          actual_keys = body_as_json[:errors].first.keys
          expected_keys = %w[status source detail]

          expect(actual_keys).to match_array(expected_keys)
        end
      end

      context 'unprocessable entity' do
        before(:each) { post '/api/v1/users/confirmation', params: { data: user_params } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
