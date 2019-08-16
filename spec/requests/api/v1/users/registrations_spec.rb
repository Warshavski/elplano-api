# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::RegistrationsController, type: :request do
  describe 'GET #cancel' do
    it 'responds with not found' do
      get('/api/v1/users/cancel')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #new' do
    it 'responds with not found' do
      get('/api/v1/users/sign_up')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #edit' do
    it 'responds with unauthorized' do
      get('/api/v1/users/edit')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PUT #update' do
    it 'responds with unauthorized' do
      put('/api/v1/users')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with unauthorized' do
      delete('/api/v1/users')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST #create' do
    let(:user_params) { build(:user_params) }

    subject { post '/api/v1/users', params: { user: user_params } }

    context 'request execution' do
      before(:each) { subject }

      context 'when request params are valid' do
        it { expect(body_as_json.keys).to eq(['meta']) }
      end

      context 'when request params are invalid' do
        let(:user_params) { build(:invalid_user_params) }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end

      context 'when request params are empty' do
        let(:user_params) { nil }

        it { expect(response).to have_http_status(:unprocessable_entity) }
      end
    end

    context 'mail send performing' do
      it 'enqueues confirmation email send' do
        expect { subject }.to(have_enqueued_job(ActionMailer::DeliveryJob))
      end
    end
  end
end
