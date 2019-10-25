# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::Reports::AbusesController, type: :request do
  include_context 'shared setup', :admin

  let(:base) { '/api/v1/admin/reports/abuses' }

  let_it_be(:report)   { create(:abuse_report) }

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
                       %w[data included],
                       %w[id type attributes relationships],
                       %w[message created_at updated_at],
                       %w[user reporter]

      context 'when abuse report is not exists' do
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

    it 'responds with a 404 status not existed abuse report' do
      delete "#{base}/0", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes abuse report' do
      expect { delete endpoint, headers: headers }.to change(AbuseReport, :count).by(-1)
    end
  end
end
