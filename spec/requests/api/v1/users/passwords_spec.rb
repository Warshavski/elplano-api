# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::PasswordsController, type: :request do
  let_it_be(:user) { create(:user, :reset_password) }

  describe 'GET #new' do
    it 'responds with unauthorized' do
      get('/api/v1/users/password/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #edit' do
    it 'responds with unauthorized' do
      get('/api/v1/users/password/edit?reset_password_token=abcdef')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PATCH #update' do
    let(:endpoint) { '/api/v1/users/password' }

    before(:each) { patch endpoint, params: { user: user_params } }

    context 'when request params are valid' do
      let(:user_params) do
        {
          password: '123456',
          password_confirmation: '123456',
          reset_password_token: 'token'
        }
      end

      it 'is expected to respond with meta' do
        expect(response).to have_http_status(:ok)
        expect(body_as_json.keys).to eq(['meta'])
      end
    end

    context 'when request params are not valid' do
      let(:user_params) do
        {
          password: '123',
          password_confirmation: nil
        }
      end

      it 'is expected to respond with errors' do
        expect(response).to have_http_status(:unprocessable_entity)

        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe 'POST #create' do
    let(:user_params) { { email: user.email } }

    let(:paranoid) { true }

    subject { post '/api/v1/users/password', params: { user: user_params }  }

    before do
      allow(Devise).to receive(:paranoid).and_return(paranoid)
    end

    context 'request execution' do
      before(:each) { subject }

      context 'when request params are valid' do
        it 'is expected to respond with meta' do
          expect(response).to have_http_status(:ok)

          expect(body_as_json.keys).to match_array(['meta'])
        end
      end

      context 'when request params are empty' do
        let(:user_params) { nil }

        it 'is expected to respond with meta' do
          expect(response).to have_http_status(:ok)

          expect(body_as_json.keys).to match_array(['meta'])
        end
      end

      context 'when request params are not valid' do
        let(:user_params) { build(:invalid_user_params) }

        context 'when paranoid mode is on' do
          let(:paranoid) { true }

          it { expect(response).to have_http_status(:ok) }
        end

        context 'when paranoid mode is off' do
          let(:paranoid) { false }

          it { expect(response).to have_http_status(:unprocessable_entity) }
        end
      end
    end

    context 'email sending' do
      it 'enqueues reset password email send' do
        expect { subject }.to(have_enqueued_job(ActionMailer::DeliveryJob))
      end
    end
  end
end
