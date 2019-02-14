require 'rails_helper'

describe Api::V1::StudentsController do
  include_context 'shared auth'

  let(:described_url) { '/api/v1/student' }

  describe '#show' do
    subject { get described_url, headers: auth_header }

    context 'anonymous user' do
      let(:auth_header) { nil }

      before(:each) { subject }

      it { expect(response).to have_http_status(:unauthorized) }

      it { expect(response.body).to eq('') }
    end

    context 'authenticated user' do
      let!(:student) { create(:student, user: user) }

      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[full_name email phone about president social_networks created_at updated_at],
                       %w[group]

      it 'returns student info of the token owner' do
        actual_full_name = body_as_json[:data][:attributes][:full_name]
        expected_full_name = user.student.full_name

        expect(actual_full_name).to eq(expected_full_name)
      end
    end
  end

  describe '#update' do
    subject { put described_url, headers: auth_header, params: request_params }

    let!(:student) { create(:student, user: user) }

    let(:student_params) { build(:student_params) }
    let(:request_params) { { data: student_params } }
    let(:invalid_request_params) { { data: build(:invalid_student_params) } }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[full_name email phone about president social_networks created_at updated_at],
                     %w[group]

    it 'returns updated student info' do
      actual_attributes = body_as_json[:data][:attributes]
      expected_attributes = student_params[:attributes]


      expect(actual_attributes['full_name']).to       eq(expected_attributes[:full_name])
      expect(actual_attributes['social_networks']).to eq(expected_attributes[:social_networks])
      expect(actual_attributes['phone']).to           eq(expected_attributes[:phone])
      expect(actual_attributes['email']).to           eq(expected_attributes[:email])
    end

    include_examples 'request errors examples'
  end
end
