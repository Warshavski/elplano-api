# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::LabelsController, type: :request do
  include_context 'shared setup', :admin

  let(:base_endpoint)     { '/api/v1/admin/labels' }
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
end
