# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::Users::UnlocksController, type: :request do
  let_it_be(:user) { create(:user, locked_at: Time.current, unlock_token: 'wat') }

  describe 'GET #new' do
    it 'responds with not found' do
      get('/api/v1/users/unlock/new')

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #show' do
    let(:unlock_url) { '/api/v1/users/unlock?unlock_token' }

    context 'when token is valid' do
      before { allow_any_instance_of(described_class).to receive(:unlock_access).and_return(user) }

      before(:each) { get "#{unlock_url}=#{user.unlock_token}" }

      it 'is expected to respond with meta' do
        expect(response).to have_http_status(:ok)

        expect(body_as_json.keys).to match_array(['meta'])
      end
    end

    context 'when token is not valid' do
      before(:each) { get "#{unlock_url}=so" }

      it 'responds with errors' do
        expect(response).to have_http_status(:unprocessable_entity)

        actual_keys = body_as_json[:errors].first.keys
        expected_keys = %w[status source detail]

        expect(actual_keys).to match_array(expected_keys)
      end
    end
  end

  describe 'POST #create' do
    let(:user_params) { { email: user.email } }

    context 'request execution' do
      before(:each) { post '/api/v1/users/unlock', params: { user: user_params } }

      context 'when request params is valid' do
        it 'is expected to respond with meta' do
          expect(response).to have_http_status(:ok)

          expect(body_as_json.keys).to match_array(['meta'])
        end
      end

      context 'when request params are not valid' do
        before { allow_any_instance_of(described_class).to receive(:successfully_sent?).and_return(false) }

        context 'when request params are not provided' do
          before(:each) { post '/api/v1/users/unlock' }

          it 'responds with errors' do
            expect(response).to have_http_status(:unprocessable_entity)

            actual_keys = body_as_json[:errors].first.keys
            expected_keys = %w[status source detail]

            expect(actual_keys).to match_array(expected_keys)
          end
        end

        context 'when not valid params are provided' do
          before(:each) { post '/api/v1/users/unlock', params: { user: user_params } }

          it { expect(response).to have_http_status(:unprocessable_entity) }
        end
      end
    end

    context 'email sending' do
      subject { post '/api/v1/users/unlock', params: { user: user_params }  }

      it 'is expected to enqueue unlock account email send' do
        expect { subject }.to(have_enqueued_job(ActionMailer::DeliveryJob))
      end
    end
  end
end
