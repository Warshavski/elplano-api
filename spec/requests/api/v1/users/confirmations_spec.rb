# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::ConfirmationsController, type: :request do
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
      subject {  get "#{confirmation_url}=#{user.confirmation_token}"  }

      it 'is expected to confirm user' do
        expect { subject }.to change { user.reload.confirmed_at }.from(nil)

        expect(response).to have_http_status(:ok)
        expect(body_as_json.keys).to eq(['meta'])
      end
    end

    context 'when token is not valid' do
      subject { get "#{confirmation_url}=so" }

      it 'responds with errors' do
        expect { subject }.not_to change { user.reload.confirmed_at }

        expect(response).to have_http_status(:unprocessable_entity)

        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe 'POST #create' do
    let(:user_params) { { email: user.email } }

    context 'when request params are valid' do
      subject { post '/api/v1/users/confirmation', params: { user: user_params } }

      context 'request performing' do
        before(:each) { subject }

        it 'is expected to respond with meta' do
          expect(response).to have_http_status(:ok)
          expect(body_as_json.keys).to match_array(['meta'])
        end
      end

      context 'email sending' do
        it 'enqueues confirmation email send' do
          expected_params = [
            'Devise::Mailer',
            'confirmation_instructions',
            'deliver_now',
            user,
            'wat',
            {}
          ]

          expect { subject }.to(have_enqueued_job(ActionMailer::DeliveryJob).with(*expected_params))
        end
      end
    end

    context 'when request params are not valid' do
      before { allow_any_instance_of(described_class).to receive(:successfully_sent?).and_return(false) }

      context 'when no params are not provided' do
        before(:each) { post '/api/v1/users/confirmation' }

        it 'is expected responds with errors' do
          expect(response).to have_http_status(:unprocessable_entity)

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
