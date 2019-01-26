require 'rails_helper'

describe Api::V1::StudentsController do
  describe '#show' do
    context 'anonymous user' do
      before(:each) { get '/api/v1/me/student' }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq('') }
    end

    context 'authenticated user' do
      let(:user)  { create(:user) }
      let(:token) { create(:token, resource_owner_id: user.id) }

      let!(:student) { create(:student, user: user) }

      before(:each) { get '/api/v1/me/student', headers: { 'Authorization' => "Bearer #{token.token}" } }

      it { expect(response).to have_http_status(:ok) }

      it 'responds with json-api format' do
        actual_keys = body_as_json[:data].keys

        expect(response.body).to look_like_json
        expect(actual_keys).to match_array(%w[id type attributes relationships])
      end

      it 'returns correct attributes set' do
        actual_keys = body_as_json[:data][:attributes].keys
        expected_keys = %w[
          full_name
          email
          phone
          created_at
          updated_at
          president
          social_networks
          about
        ]

        expect(actual_keys).to match_array(expected_keys)
      end

      it 'returns group in relationships' do
        relationships_keys = body_as_json[:data][:relationships].keys

        expect(relationships_keys).to match_array(['group'])
      end

      it 'returns student info of the token owner' do
        actual_username = body_as_json[:data][:attributes][:full_name]

        expect(actual_username).to eq(user.student.full_name)
      end
    end
  end

  describe '#update' do
    context 'anonymous user' do
      before(:each) { put '/api/v1/me/student' }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq('') }
    end

    context 'authenticated user' do
      let(:user)  { create(:user) }
      let(:token) { create(:token, resource_owner_id: user.id) }

      let!(:student) { create(:student, user: user) }

      let(:student_params) { build(:student_params) }

      context 'valid parameters' do
        before(:each) do
          put '/api/v1/me/student',
              headers: { 'Authorization' => "Bearer #{token.token}" },
              params: { data: student_params }
        end

        it { expect(response).to have_http_status(:ok) }

        it 'responds with json-api format' do
          actual_keys = body_as_json[:data].keys

          expect(response.body).to look_like_json
          expect(actual_keys).to match_array(%w[id type attributes relationships])
        end

        it 'returns correct attributes set' do
          actual_keys = body_as_json[:data][:attributes].keys
          expected_keys = %w[
          full_name
          email
          phone
          created_at
          updated_at
          president
          social_networks
          about
        ]

          expect(actual_keys).to match_array(expected_keys)
        end

        it 'returns group in relationships' do
          relationships_keys = body_as_json[:data][:relationships].keys

          expect(relationships_keys).to match_array(['group'])
        end

        it 'returns updated student info' do
          actual_attributes = body_as_json[:data][:attributes]
          expected_attributes = student_params[:attributes]


          expect(actual_attributes['full_name']).to       eq(expected_attributes[:full_name])
          expect(actual_attributes['social_networks']).to eq(expected_attributes[:social_networks])
          expect(actual_attributes['phone']).to           eq(expected_attributes[:phone])
          expect(actual_attributes['email']).to           eq(expected_attributes[:email])
        end
      end

      context 'invalid parameters' do
        it 'responds with a 400 status on request with empty params' do
          put '/api/v1/me/student',
              headers: { 'Authorization' => "Bearer #{token.token}" }, params: nil

          expect(response).to have_http_status(:bad_request)
        end

        it 'responds with a 400 status on request without params' do
          put '/api/v1/me/student', headers: { 'Authorization' => "Bearer #{token.token}" }

          expect(response).to have_http_status(:bad_request)
        end
      end
    end
  end
end
