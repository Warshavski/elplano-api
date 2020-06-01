# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::GroupsController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:random_group)    { create(:group) }
  let_it_be(:expected_group)  { create(:group, title: 'expected', number: 'group') }

  let_it_be(:base_endpoint)     { '/api/v1/admin/groups' }
  let_it_be(:resource_endpoint) { "#{base_endpoint}/#{expected_group.id}" }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers, params: params }

    let_it_be(:params) { {} }

    before(:each) { subject }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when no request params are provided' do
      it 'is expected to respond with groups list' do
        expect(response).to have_http_status(:ok)

        expect(json_data.count).to be(2)
      end
    end

    context 'when search filter is provided' do
      let_it_be(:params) do
        {
          filter: { search: expected_group.title }
        }
      end

      it 'is expected to respond with filtered groups list' do
        expect(response).to have_http_status(:ok)

        expect(json_data.map { |e| e[:id].to_i }).to eq([expected_group.id])
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it 'is expected to respond with detailed information about group' do
      expect(response).to have_http_status(:ok)

      expect(json_data['type']).to eq('group')
      expect(json_data['id']).to eq(expected_group.id.to_s)
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[title number created_at updated_at],
                     %w[president students]

    context 'when requested used does not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
