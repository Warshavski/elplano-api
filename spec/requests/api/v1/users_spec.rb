# frozen_string_literal: true

require 'rails_helper'

describe Api::V1::UsersController, type: :request do
  include_context 'shared setup'

  let_it_be(:endpoint) { '/api/v1/user' }

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    before(:each) { subject }

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq("{\"errors\":[{\"status\":401,\"title\":\"Authorization error\",\"detail\":\"The access token is invalid\",\"source\":{\"pointer\":\"Authorization Header\"}}]}") }
    end

    context 'when user is authenticated user' do
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data['type']).to eq('user') }

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[email username avatar_url admin confirmed banned locked locale created_at updated_at],
                       %w[student]

      it 'returns token owner' do
        actual_username = json_data.dig(:attributes, :username)
        expected_username = user.username

        expect(actual_username).to eq(expected_username)
      end
    end
  end

  describe 'PATCH #update' do
    subject { put endpoint, headers: headers, params: request_params }

    let_it_be(:student, reload: true) { create(:student, user: user) }

    let(:user_params) { build(:profile_params) }
    let(:request_params) { { user: user_params } }
    let(:invalid_request_params) { { user: build(:invalid_profile_params) } }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('user') }

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[email username avatar_url admin confirmed banned locked locale created_at updated_at],
                     %w[student]

    it 'returns updated student info' do
      expect(user.reload.locale).to       eq(user_params[:locale])
      expect(student.full_name).to        eq(user_params.dig(:student_attributes, :full_name))
      expect(student.social_networks).to  eq(user_params.dig(:student_attributes,:social_networks))
      expect(student.phone).to            eq(user_params.dig(:student_attributes,:phone))
      expect(student.email).to            eq(user_params.dig(:student_attributes,:email))
    end

    include_examples 'request errors examples'
  end
end
