require 'rails_helper'

describe Api::V1::Users::RegistrationsController do

  describe '#cancel' do
    it 'responds with not found' do
      get('/api/v1/users/cancel')

      expect(response).to have_http_status(:no_content)
    end
  end

  describe '#new' do
    it 'responds with not found' do
      get('/api/v1/users/sign_up')

      expect(response).to have_http_status(:no_content)
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

    it 'responds with json-api format' do
      actual_keys = body_as_json[:data].keys

      expect(response.body).to look_like_json
      expect(actual_keys).to match_array(%w[id type attributes])
    end

    it { expect(body_as_json).to include(:meta) }

    it 'returns with correct attributes' do
      actual_keys = body_as_json[:data][:attributes].keys
      expected_keys = %w[email username avatar_url created_at updated_at]

      expect(actual_keys).to match_array(expected_keys)
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
end
