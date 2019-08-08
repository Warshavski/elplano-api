# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::RegistrationsController do
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

    before(:each) { post '/api/v1/users', params: { user: user_params } }

    context 'when request params are valid' do
      include_examples 'json:api examples',
                       %w[data meta],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]

      it 'returns registered user' do
        actual_username = json_data.dig(:attributes, :username)
        expected_username = user_params[:username]

        expect(actual_username).to eq(expected_username)
      end

      it 'returns unconfirmed user' do
        confirmation_flag = json_data.dig(:attributes, :confirmed)

        expect(confirmation_flag).to be false
      end

      it 'returns non admin user' do
        admin_flag = json_data.dig(:attributes, :admin)

        expect(admin_flag).to be false
      end

      # TODO : fix "undefined method `env' for nil:NilClass"
      #
      # context 'email confirmation' do
      #   around do |example|
      #     perform_enqueued_jobs { example.run }
      #   end
      #
      #   it 'does not authenticate user and sends confirmation email' do
      #     expect(ActionMailer::Base.deliveries.last.to.first).to eq(user_params[:attributes][:email])
      #     expect(subject.current_user).to be_nil
      #   end
      # end
    end

    context 'when request params are invalid' do
      let(:user_params) { build(:invalid_user_params) }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when request params are empty' do
      let(:user_params) { nil }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end
