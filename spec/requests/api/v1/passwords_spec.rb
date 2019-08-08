# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PasswordsController, type: :request do
  describe 'PUT #update' do
    let_it_be(:user)  { create(:user, password: '123456') }
    let_it_be(:token) { create(:token, resource_owner_id: user.id) }

    let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }

    let_it_be(:endpoint) { '/api/v1/password' }

    subject do
      patch endpoint, params: params, headers: headers
    end

    before(:each) { subject }

    context 'when all params are valid' do
      let_it_be(:params) do
        {
          user: {
            current_password: '123456',
            password: '654321',
            password_confirmation: '654321'
          }
        }
      end

      it { expect(response).to have_http_status(:ok) }

      it { expect(body_as_json.keys).to match_array(['meta']) }
    end

    context 'when password params is blank' do
      let_it_be(:params) do
        {
          user: {
            current_password: '123456',
            password_confirmation: '654321'
          }
        }
      end

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when current_password is blank' do
      let_it_be(:params) do
        {
          user: {
            password: '654321',
            password_confirmation: '654321'
          }
        }
      end

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when password_confirmation is blank' do
      let_it_be(:params) do
        {
          user: {
            current_password: '123456',
            password: '654321'
          }
        }
      end

      it { expect(response).to have_http_status(:bad_request) }
    end

    context 'when current_password is wrong' do
      let_it_be(:params) do
        {
          user: {
            current_password: '654321',
            password: '654321',
            password_confirmation: '654321'
          }
        }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when new password is not valid' do
      let_it_be(:params) do
        {
          user: {
            current_password: '123456',
            password: '123',
            password_confirmation: '654321'
          }
        }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end

    context 'when password and password confirmation are not equal' do
      let_it_be(:params) do
        {
          user: {
            current_password: '123456',
            password: '654321',
            password_confirmation: '123456'
          }
        }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end
end
