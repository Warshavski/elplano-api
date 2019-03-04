require 'rails_helper'

describe Api::V1::Users::PasswordsController do
  let_it_be(:user) { create(:user, :reset_password) }

  describe '#new' do
    it 'responds with unauthorized' do
      get('/api/v1/users/password/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#edit' do
    it 'responds with unauthorized' do
      get('/api/v1/users/password/edit?reset_password_token=abcdef')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#update' do
    let(:endpoint) { '/api/v1/users/password' }

    before(:each) { patch endpoint, params: { data: user_params } }

    context 'valid params' do
      let(:user_params) do
        {
          type: 'User',
          attributes: {
            password: '123456',
            password_confirmation: '123456',
            reset_password_token: 'token'
          }
        }
      end

      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data meta],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]
    end

    context 'invalid params' do
      let(:user_params) do
        {
          type: 'User',
          attributes: {
            pasword: '123',
            pasword_confirmation: nil
          }
        }
      end

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
          login: user.email
        }
      }
    end

    let(:paranoid) { true }

    subject { post '/api/v1/users/password', params: { data: user_params }  }

    before do
      allow(Devise).to receive(:paranoid).and_return(paranoid)
    end

    before(:each) { subject }

    context 'valid params' do
      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json.keys).to match_array(['meta'])}
    end

    context 'empty params' do
      let(:user_params) { nil }

      it { expect(response).to have_http_status(:bad_request) }

      it 'responds with errors' do
        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end

    context 'invalid params' do
      let(:user_params) { build(:invalid_user_params) }

      context 'paranoid mode on' do
        let(:paranoid) { true }

        it { expect(response).to have_http_status(:ok) }
      end

      context 'paranoid mode off' do
        let(:paranoid) { false }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end
  end
end
