# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Group management', type: :request do
  include_context 'shared setup'

  let(:group_url) { '/api/v1/group' }

  let(:group_params) { build(:group_params) }

  let(:request_params) { { data: group_params } }
  let(:invalid_request_params) { { data: build(:invalid_group_params) } }

  describe 'GET #show' do
    let_it_be(:student) { create(:student, :group_member, user: user) }

    before(:each) { get group_url, headers: headers }

    it 'responds with a 200 status' do
      expect(response).to have_http_status(:ok)
    end

    include_examples 'json:api examples',
                     %w[data],
                     %w[id type attributes relationships],
                     %w[title number created_at updated_at],
                     %w[students]
  end

  describe 'POST #create' do
    subject { post group_url, params: request_params, headers: headers }

    context 'student with group' do
      context 'simple group member' do
        let_it_be(:student) { create(:student, :group_member, user: user) }

        before(:each) { subject }

        it 'responds with 403 - forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'group owner' do
        let_it_be(:student) { create(:student, :group_supervisor, user: user) }

        before(:each) { subject }

        it 'responds with 403 - forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context 'student with no group' do
      let_it_be(:student) { create(:student, user: user) }

      before(:each) { subject }

      context 'valid params' do
        it 'responds with a 201 status' do
          expect(response).to have_http_status(:created)
        end

        include_examples 'json:api examples',
                         %w[data],
                         %w[id type attributes relationships],
                         %w[title number created_at updated_at],
                         %w[students]
      end

      include_examples 'request errors examples'
    end
  end

  describe 'PUT #update' do
    subject { put group_url, params: request_params, headers: headers }

    context 'simple group owner' do
      let_it_be(:student) { create(:student, :group_member, user: user) }

      before(:each) { subject }

      it 'responds with 403 - forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'student with no group' do
      let_it_be(:student) { create(:student, user: user) }

      before(:each) { subject }

      it 'responds with 403 - forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'group owner' do
      let_it_be(:student) { create(:student, :group_supervisor, user: user) }

      before(:each) { subject }

      it 'responds with a 200 status' do
        expect(response).to have_http_status(:ok)
      end

      include_examples 'json:api examples',
                       %w[data],
                       %w[id type attributes relationships],
                       %w[title number created_at updated_at],
                       %w[students]

      it 'updates a supervised group information' do
        actual_group_title = student.supervised_group.reload.title
        expected_group_title = group_params[:attributes][:title]

        expect(actual_group_title).to eq(expected_group_title)
      end

      include_examples 'request errors examples'
    end
  end

  describe 'DELETE #destroy' do
    let_it_be(:student) { create(:student, :group_supervisor, user: user) }

    it 'responds with a 204 status' do
      delete group_url, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it 'deletes group' do
      expect { delete group_url, headers: headers }.to change(Group, :count).by(-1)
    end
  end
end
