# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ClassmatesController, type: :request do
  include_context 'shared setup'

  let(:base) { '/api/v1/classmates' }

  let_it_be(:random_student) { create(:student) }
  let_it_be(:student) { create(:student, user: user) }

  let_it_be(:group) { create(:group, students: [student, random_student]) }

  subject { get endpoint, headers: headers, params: params }

  let(:params) { {} }

  before(:each) { subject }

  describe 'GET #index' do
    let(:endpoint) { base }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when user is authorized user' do
      context 'when no request params are provided' do
        it { expect(response).to have_http_status(:ok) }

        it { expect(json_data.count).to be(2) }
      end

      context 'when search filter is provided' do
        let(:params) do
          {
            filters: {
              search: random_student.email
            }.to_json
          }
        end

        it { expect(response).to have_http_status(:ok) }

        it { expect(json_data.map { |e| e[:id].to_i }).to eq([random_student.id]) }
      end
    end

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  describe 'GET #show' do
    let(:endpoint)  { "#{base}/#{student.id}" }

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when user is authorized user' do
      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[full_name email phone about president social_networks created_at updated_at],
                       %w[user group]


      context 'when user not existed group member' do
        let(:user) { create(:student, :group_member).user }
        let(:endpoint) { "#{base}/0" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end
  end
end
