require 'rails_helper'

describe Api::V1::Users::RegistrationsController do

  describe '#cancel' do
    it 'responds with not found' do
      get('/api/v1/users/cancel')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#new' do
    it 'responds with not found' do
      get('/api/v1/users/sign_up')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#edit' do
    it 'responds with unauthorized' do
      get('/api/v1/users/edit')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#update' do
    it 'responds with unauthorized' do
      put('/api/v1/users')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#destroy' do
    it 'responds with unauthorized' do
      delete('/api/v1/users')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe '#create' do
    let(:user_params) { build(:user_params) }

    before(:each) { post '/api/v1/users', params: { data: user_params } }

    context 'valid params' do
      include_examples 'json:api examples',
                       %w[data meta],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed created_at updated_at],
                       %w[student]

      it 'returns registered user' do
        actual_username = body_as_json[:data][:attributes][:username]
        expected_username = user_params[:attributes][:username]

        expect(actual_username).to eq(expected_username)
      end

      it 'returns unconfirmed user' do
        confirmation_flag = body_as_json[:data][:attributes][:confirmed]

        expect(confirmation_flag).to be false
      end


      it 'returns non admin user' do
        admin_flag = body_as_json[:data][:attributes][:admin]

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

    context 'invalid params' do
      let(:user_params) { build(:invalid_user_params) }

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'empty params' do
      let(:user_params) { nil }

      it { expect(response).to have_http_status(:bad_request) }
    end
  end
end
