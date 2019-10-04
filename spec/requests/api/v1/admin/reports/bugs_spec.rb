# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::Reports::BugsController, type: :request do
  include_context 'shared setup', :admin

  let(:base) { '/api/v1/admin/reports/bugs' }

  let_it_be(:report)   { create(:bug_report) }

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
    let(:endpoint)  { "#{base}/#{report.id}" }

    context 'when user is anonymous' do
      let(:headers) { nil }

      it { expect(response).to have_http_status(:unauthorized) }
    end

    context 'when user is authorized user' do
      it { expect(response).to have_http_status(:ok) }

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes],
                       %w[message created_at updated_at]


      context 'when user is not exists' do
        let(:endpoint) { "#{base}/0" }

        it { expect(response).to have_http_status(:not_found) }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:endpoint)  { "#{base}/#{report.id}" }

    it 'responds with a 204 status' do
      delete endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed bug report' do
      delete "#{base}/0", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes bug report' do
      expect { delete endpoint, headers: headers }.to change(BugReport, :count).by(-1)
    end
  end
end
