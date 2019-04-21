require 'rails_helper'

describe Api::V1::StudentsController, type: :request do
  include_context 'shared setup'

  let(:endpoint) { '/api/v1/student' }

  describe 'GET #show' do
    subject { get endpoint, headers: headers }

    context 'anonymous user' do
      let(:headers) { nil }

      before(:each) { subject }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq("{\"errors\":[{\"status\":401,\"title\":\"Authorization error\",\"detail\":\"Invalid authorization token\",\"source\":{\"pointer\":\"Authorization Header\"}}]}") }
    end

    context 'authenticated user' do
      let_it_be(:student) { create(:student, user: user) }

      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data['type']).to eq('student') }

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[full_name email phone about president social_networks created_at updated_at],
                       %w[group user]

      it 'returns student info of the token owner' do
        actual_full_name = json_data.dig(:attributes, :full_name)
        expected_full_name = user.student.full_name

        expect(actual_full_name).to eq(expected_full_name)
      end
    end
  end

  describe 'PATCH #update' do
    subject { put endpoint, headers: headers, params: request_params }

    let_it_be(:student) { create(:student, user: user) }

    let(:student_params) { build(:student_params) }
    let(:request_params) { { data: student_params } }
    let(:invalid_request_params) { { data: build(:invalid_student_params) } }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('student') }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[full_name email phone about president social_networks created_at updated_at],
                     %w[group user]

    it 'returns updated student info' do
      actual_attributes = json_data[:attributes]
      expected_attributes = student_params[:attributes]


      expect(actual_attributes['full_name']).to       eq(expected_attributes[:full_name])
      expect(actual_attributes['social_networks']).to eq(expected_attributes[:social_networks])
      expect(actual_attributes['phone']).to           eq(expected_attributes[:phone])
      expect(actual_attributes['email']).to           eq(expected_attributes[:email])
    end

    include_examples 'request errors examples'
  end
end
