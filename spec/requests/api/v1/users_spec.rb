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
                       %w[email settings timezone username avatar admin confirmed banned locked locale created_at updated_at],
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
                     %w[email settings timezone username avatar admin confirmed banned locked locale created_at updated_at],
                     %w[student]

    it 'returns updated student info' do
      expect(user.reload.locale).to       eq(user_params[:locale])
      expect(student.full_name).to        eq(user_params.dig(:student_attributes, :full_name))
      expect(student.phone).to            eq(user_params.dig(:student_attributes, :phone))
      expect(student.email).to            eq(user_params.dig(:student_attributes, :email))

      user_params.dig(:student_attributes, :social_networks).each_with_index do |network, index|
        expect(student.social_networks[index].network).to  eq(network[:network])
        expect(student.social_networks[index].url).to  eq(network[:url])
      end
    end

    include_examples 'request errors examples'

    context 'when avatar is present' do
      let(:file)      { fixture_file_upload('spec/fixtures/files/dk.png') }
      let(:metadata)  { AvatarUploader.new(:cache).upload(file) }

      let(:request_params) do
        core_params = build(:profile_params)

        core_params.merge!(avatar: metadata.to_json)

        { user: core_params }
      end

      it { expect(response).to have_http_status(:ok) }

      context 'when avatar metadata is not valid' do
        let(:request_params) do
          core_params = build(:profile_params)

          core_params.merge!(
            avatar: {
              id: "344f98a5e8c879851116c54e9eb5e610.jpg",
              storage:"cache",
              metadata:{
                filename:"KMZxXr_1.jpg",
                size:187165,
                mime_type:"image/jpeg"
              }
            }.to_json
          )

          { user: core_params }
        end

        it { expect(response).to have_http_status(:bad_request) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:user)  { create(:user, password: '123456') }
    let_it_be(:token) { create(:token, resource_owner_id: user.id) }

    let(:headers) { { 'Authorization' => "Bearer #{token.token}" } }

    context 'when params are valid' do
      let_it_be(:params) { { user: { password: '123456' } } }

      it 'responds with a 204 status' do
        delete endpoint, headers: headers, params: params

        expect(response).to have_http_status(:no_content)
      end

      it 'deletes a user' do
        expect { delete endpoint, headers: headers, params: params }.to change(User, :count).by(-1)
      end
    end

    context 'when params are valid' do
      context 'when params is not provided at all' do
        let_it_be(:params) { {} }

        it 'returns error with 400(bad request)' do
          delete endpoint, headers: headers, params: params

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when password is not provided' do
        let_it_be(:params) { { user: {} } }

        it 'returns error with 400(bad request)' do
          delete endpoint, headers: headers, params: params

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when nil password is provided' do
        let_it_be(:params) { { user: { password: nil } } }

        it 'returns error with 400(bad request)' do
          delete endpoint, headers: headers, params: params

          expect(response).to have_http_status(:bad_request)
        end
      end

      context 'when password is not valid' do
        let_it_be(:params) { { user: { password: 'wat_password?' } } }

        it 'returns error with 400(bad request)' do
          delete endpoint, headers: headers, params: params

          expect(response).to have_http_status(:forbidden)
        end
      end
    end
  end
end
