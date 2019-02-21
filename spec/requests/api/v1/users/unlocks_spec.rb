require 'rails_helper'

describe Api::V1::Users::UnlocksController do
  let_it_be(:user) { create(:user, locked_at: Time.now, unlock_token: 'wat') }

  describe '#new' do
    it 'responds with not found' do
      get('/api/v1/users/unlock/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#show' do
    let(:unlock_url) { '/api/v1/users/unlock?unlock_token' }

    context 'valid token' do
      before { allow_any_instance_of(described_class).to receive(:unlock_access).and_return(user) }

      before(:each) { get "#{unlock_url}=#{user.unlock_token}" }

      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data meta],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]
    end

    context 'invalid token' do
      before(:each) { get "#{unlock_url}=so" }

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
      before(:each) { post '/api/v1/users/unlock', params: { data: user_params } }

      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data meta],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]
    end

    context 'invalid params' do
      before { allow_any_instance_of(described_class).to receive(:successfully_sent?).and_return(false) }

      context 'bad request' do
        before(:each) { post '/api/v1/users/unlock' }

        it { expect(response).to have_http_status(:bad_request) }

        it 'responds with errors' do
          actual_keys = body_as_json[:errors].first.keys
          expected_keys = %w[status source detail]

          expect(actual_keys).to match_array(expected_keys)
        end
      end

      context 'unprocessable entity' do
        before(:each) { post '/api/v1/users/unlock', params: { data: user_params } }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
