# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Group::StudentsController, type: :request do
  include_context 'shared setup'

  let(:base) { '/api/v1/group/students' }

  let_it_be(:student)   { create(:student, :group_member, user: user) }

  subject { get endpoint, headers: headers }

  before(:each) { subject }

  describe 'GET #index' do
    let(:endpoint) { base }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when user is authorized user' do
      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to eq(1) }
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
