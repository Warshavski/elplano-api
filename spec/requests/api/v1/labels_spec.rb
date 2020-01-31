# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::LabelsController, type: :request do
  include_context 'shared setup', :user

  let(:base_endpoint)     { '/api/v1/labels' }
  let(:resource_endpoint) { "#{base_endpoint}/#{label.id}" }

  let_it_be(:student) { create(:student, :group_supervisor, user: user) }
  let_it_be(:label)   { create(:label, group: student.group) }

  let(:label_params)  { attributes_for(:label).without(:group_id) }

  let(:request_params) { { label: label_params } }
  let(:invalid_request_params) { { label: label_params.merge(color: 'wat', title: '') } }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers }

    let_it_be(:labels) { create_list(:label, 2, group: student.group) }

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

    it 'is expected to respond with requested label' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('label')

      actual_label = json_data.dig(:attributes, :title)
      expected_label = label.title

      expect(actual_label).to eq(expected_label)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[title description color text_color created_at updated_at]

    context 'when requested label does not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'POST #create' do
    subject { post base_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it 'is expected to create label and respond with created label' do
      expect(response).to have_http_status(:created)
      expect(json_data['type']).to eq('label')

      actual_title = json_data.dig(:attributes, :title)
      expected_title = label_params[:title].downcase

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[title description color text_color created_at updated_at]

    include_examples 'request errors examples'
  end

  describe 'PUT #update' do
    subject { put resource_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    it 'is expected to update and respond with updated label' do
      expect(response).to have_http_status(:ok)
      expect(json_data['type']).to eq('label')

      actual_title = label.reload.title
      expected_title = label_params[:title].downcase

      expect(actual_title).to eq(expected_title)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[title description color text_color created_at updated_at]

    include_examples 'request errors examples'

    context 'when requested label does not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'DELETE #destroy' do
    it 'responds with a 204 status' do
      delete resource_endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'responds with a 404 status on not existed label' do
      delete "#{base_endpoint}/0", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'deletes announcement' do
      expect { delete resource_endpoint, headers: headers }.to change(Label, :count).by(-1)
    end
  end
end
