# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::AnnouncementsController, type: :request do
  include_context 'shared setup', :admin

  let(:base_endpoint)     { '/api/v1/admin/announcements' }
  let(:resource_endpoint) { "#{base_endpoint}/#{announcement.id}" }

  let_it_be(:announcement) { create(:announcement) }

  let(:announcement_params)  { build(:announcement_params) }

  let(:request_params) { { announcement: announcement_params } }
  let(:invalid_request_params) { { announcement: build(:invalid_announcement_params) } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:announcements) { create_list(:announcement, 2) }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when no filter params are provided' do
      before(:each) { subject }

      it { expect(response).to have_http_status(:ok) }

      it { expect(json_data.count).to be(3) }
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('announcement') }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[message start_at end_at background_color foreground_color created_at updated_at]

    it 'returns correct expected data' do
      actual_message = json_data.dig(:attributes, :message)
      expected_message = announcement.message

      expect(actual_message).to eq(expected_message)
    end

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/wat_event?" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:created) }

    it { expect(json_data['type']).to eq('announcement') }

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[message start_at end_at background_color foreground_color created_at updated_at]

    it 'returns created model' do
      actual_message = json_data.dig(:attributes, :message)
      expected_message = announcement_params[:message]

      expect(actual_message).to eq(expected_message)
    end

    include_examples 'request errors examples'
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it { expect(response).to have_http_status(:ok) }

    it { expect(json_data['type']).to eq('announcement') }

    it 'updates a announcement model' do
      actual_message = announcement.reload.message
      expected_message = announcement_params[:message]

      expect(actual_message).to eq(expected_message)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[message start_at end_at background_color foreground_color created_at updated_at]

    include_examples 'request errors examples'

    context 'when request params are not valid' do
      let(:resource_endpoint) { "#{base_endpoint}/0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete resource_endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status not existed announcement' do
      delete "#{base_endpoint}/0", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes announcement' do
      expect { delete resource_endpoint, headers: headers }.to change(Announcement, :count).by(-1)
    end
  end
end
