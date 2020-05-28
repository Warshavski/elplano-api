# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  include_context 'shared setup'

  let(:group_endpoint) { '/api/v1/group' }

  let(:group_params) { build(:group_params) }

  let(:request_params) { { group: group_params } }
  let(:invalid_request_params) { { group: build(:invalid_group_params) } }

  describe 'GET #show' do
    let_it_be(:student) { create(:student, :group_member, user: user) }

    before(:each) { get group_endpoint, headers: headers }

    it 'is expected to respond with group entity' do
      expect(response).to have_http_status(:ok)

      expect(json_data['type']).to eq('group')
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes],
                     %w[title number created_at updated_at]
  end

  describe 'POST #create' do
    subject { post group_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when student already in the group' do
      context 'when student is a regular group member' do
        let_it_be(:student) { create(:student, :group_member, user: user) }

        it { expect(response).to have_http_status(:forbidden) }
      end

      context 'when student is a group owner' do
        let_it_be(:student) { create(:student, :group_supervisor, user: user) }

        it { expect(response).to have_http_status(:forbidden) }
      end
    end

    context 'when student have no group' do
      let_it_be(:student) { create(:student, user: user) }

      context 'when request params are valid' do
        it {  expect(response).to have_http_status(:created) }

        include_examples 'json:api examples',
                         %w[data],
                         %w[id type attributes],
                         %w[title number created_at updated_at]
      end

      include_examples 'request errors examples'
    end
  end

  describe 'PUT #update' do
    subject { put group_endpoint, params: request_params, headers: headers }

    before(:each) { subject }

    context 'when student is a regular group member' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      it { expect(response).to have_http_status(:forbidden) }
    end

    context 'when student have no group' do
      let_it_be(:student) { create(:student, user: user) }

      it { expect(response).to have_http_status(:forbidden) }
    end

    context 'when student is a group owner' do
      let_it_be(:student) { create(:student, :group_supervisor, user: user) }

      it 'is expected to respond with group entity' do
        expect(response).to have_http_status(:ok)
        expect(json_data['type']).to eq('group')
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes],
                       %w[title number created_at updated_at]

      it 'updates a supervised group information' do
        actual_group_title = student.supervised_group.reload.title
        expected_group_title = group_params[:title]

        expect(actual_group_title).to eq(expected_group_title)
      end

      include_examples 'request errors examples'
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:student) { create(:student, :group_supervisor, user: user) }

    it 'responds with a 204 status' do
      delete group_endpoint, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'deletes a group' do
      expect { delete group_endpoint, headers: headers }.to change(Group, :count).by(-1)
    end
  end
end
