# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :request do
  include_context 'shared setup', :admin

  let_it_be(:random_user) { create(:user) }

  let_it_be(:base_endpoint)     { '/api/v1/admin/users' }
  let_it_be(:resource_endpoint) { "#{base_endpoint}/#{random_user.id}" }

  describe 'GET #index' do
    subject { get base_endpoint, headers: headers, params: params }

    let_it_be(:params) { {} }

    before(:each) { subject }

    context 'N+1' do
      bulletify { subject }
    end

    context 'when no request params are provided' do
      it 'is expected to respond with users collection' do
        expect(response).to have_http_status(:ok)

        expect(json_data.count).to be(2)
      end
    end

    context 'when status filter is provided' do
      let_it_be(:params) do
        {
          filters: {
            status: 'banned'
          }.to_json
        }
      end

      let_it_be(:banned_user) { create(:user, :banned) }

      it 'is expected to respond with banned users' do
        expect(response).to have_http_status(:ok)

        expect(json_data.map { |e| e[:id].to_i }).to eq([banned_user.id])
      end
    end

    context 'when search filter is provided' do
      let_it_be(:params) do
        {
          filters: {
            search: random_user.email
          }.to_json
        }
      end

      it 'is expected to respond with users filtered by search term' do
        expect(response).to have_http_status(:ok)

        expect(json_data.map { |e| e[:id].to_i }).to eq([random_user.id])
      end
    end
  end

  describe 'GET #show' do
    subject { get resource_endpoint, headers: headers }

    before(:each) { subject }

    it 'is expected to respond with user entity' do
      expect(response).to have_http_status(:ok)

      expect(json_data['id']).to eq(random_user.id.to_s)
      expect(json_data['type']).to eq('user')
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[email username settings timezone admin avatar confirmed banned locked locale created_at updated_at],
                     %w[student status]

    context 'when requested used does not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'PATCH #update' do
    let_it_be(:action_type) { 'ban' }

    subject { patch resource_endpoint, params: { action_type: action_type }, headers: headers }

    before(:each) { subject }

    it 'is expected to respond with user entity' do
      expect(response).to have_http_status(:ok)

      expect(json_data['id']).to eq(random_user.id.to_s)
      expect(json_data['type']).to eq('user')
      expect(json_data.dig('attributes', 'banned')).to be(true)
    end

    include_examples 'json:api examples',
                     %w[data included],
                     %w[id type attributes relationships],
                     %w[email username settings timezone admin avatar confirmed banned locked locale created_at updated_at],
                     %w[student status]

    context 'when requested used does not exists' do
      let(:resource_endpoint) { "#{base_endpoint}/0" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:random_user) { create(:user) }

    it 'is expected to respond with a 204 status' do
      delete resource_endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'is expected to respond with a 404 status for not existed user' do
      delete "#{base_endpoint}/0", headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it 'is expected to delete user' do
      expect { delete resource_endpoint, headers: headers }.to change(User, :count).by(-1)
    end
  end
end
